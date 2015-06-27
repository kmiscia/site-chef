#
# Cookbook Name:: site-app
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rails'
include_recipe 'passenger_apache2'
include_recipe 'imagemagick::rmagick'
include_recipe 'sphinx'
include_recipe 'redis::install_from_package'
include_recipe 'resque'

# Some dependency requires V8 JS engine
# to be installed and isnt' install it? 
# Just install it for now...
include_recipe 'nodejs'

ENV['RAILS_ENV'] = node[:site_app][:environment]

file "/var/log/resque.log" do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

template '/etc/init/resque.conf' do
  source 'resque.conf.erb'
  owner 'www-data'
  group 'www-data'
  mode 0664
  notifies :restart, 'service[resque]'
end

service 'resque' do
  provider Chef::Provider::Service::Upstart
  supports status: true, start: true, stop: true, restart: true
  action [ :enable, :start ]
end

file "/var/log/thinking_sphinx.log" do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

template '/etc/init/thinking_sphinx.conf' do
  source 'thinking_sphinx.conf.erb'
  owner 'www-data'
  group 'www-data'
  mode 0664
  notifies :restart, 'service[thinking_sphinx]'
end

service 'thinking_sphinx' do
  provider Chef::Provider::Service::Upstart
  supports status: true, start: true, stop: true, restart: true
  action [ :enable, :start ]
end

directory "/apps/site" do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
  recursive true
end

git "#{Chef::Config[:file_cache_path]}/site" do
  repository node[:site_app][:repository]
  revision node[:site_app][:revision]
  destination node[:site_app][:root]
  action :sync
  user 'www-data'
  group 'www-data'
end

execute "install gems" do
  cwd node[:site_app][:root]
  command "#{node[:ruby][:dir]}/bin/bundle install"
end

web_app "site" do
  docroot "#{node[:site_app][:root]}/public"
  server_name "site.#{node[:domain]}"
  server_aliases [ "site", node[:domain] ]
  rails_env ENV['RAILS_ENV']
end

file "#{node[:site_app][:root]}/log/development.log" do
  owner 'www-data'
  group 'www-data'
  mode '0666'
  action :create_if_missing
end

file "#{node[:site_app][:root]}/log/production.log" do
  owner 'www-data'
  group 'www-data'
  mode '0666'
  action :create_if_missing
end

execute "load db schema" do
  cwd node[:site_app][:root]
  user 'www-data'
  group 'www-data'
  command "#{node[:ruby][:dir]}/bin/bundle exec rake db:schema:load"
end

execute "seed db" do
  cwd node[:site_app][:root]
  user 'www-data'
  group 'www-data'
  command "#{node[:ruby][:dir]}/bin/bundle exec rake db:seed"
end

mysql_service 'sphinx_mysql_service' do
  port '3306'
  # The latest version supported on Ubuntu 12.04 
  # by this cookbook is 5.5
  version '5.5' 
  initial_root_password 'changeme'
  action [:create, :start]
end

execute "precompile rails assets" do
  cwd node[:site_app][:root]
  user 'www-data'
  group 'www-data'
  command "#{node[:ruby][:dir]}/bin/bundle exec rake assets:precompile RAILS_ENV=#{ENV['RAILS_ENV']}"
end

execute "build the sphinx indexes" do
  cwd node[:site_app][:root]
  user 'www-data'
  group 'www-data'
  command "#{node[:ruby][:dir]}/bin/bundle exec rake ts:rebuild RAILS_ENV=#{ENV['RAILS_ENV']}"
end

