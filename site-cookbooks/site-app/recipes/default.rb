#
# Cookbook Name:: site-app
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Some dependency/process requires a JS engine to 
# be installed. Just install nodejs for now. There
# may be lighter solutions than including all of nodejs
include_recipe 'nodejs'

include_recipe 'rails'
include_recipe 'passenger_apache2'
include_recipe 'imagemagick::rmagick'
include_recipe 'site-app::backup'

ENV['RAILS_ENV'] = node[:site_app][:environment]

directory "/apps/site" do
  mode '0755'
  action :create
  recursive true
  owner 'www-data'
  group 'www-data'
end

git "#{Chef::Config[:file_cache_path]}/site" do
  repository node[:site_app][:repository]
  revision node[:site_app][:revision]
  destination node[:site_app][:root]
  action :sync
  user 'www-data'
  group 'www-data'
end

rbenv_execute "bundle install" do
  cwd node[:site_app][:root]
  command "bundle install --verbose"
  ruby_version '2.1.3'
end

include_recipe 'site-app::encryption'

web_app "site" do
  docroot "#{node[:site_app][:root]}/public"
  server_name "site.#{node[:domain]}"
  server_aliases [ "site", node[:domain] ]
  rails_env ENV['RAILS_ENV']
end

file "#{node[:site_app][:root]}/log/production.log" do
  owner 'www-data'
  group 'www-data'
  mode '0666'
  action :create_if_missing
end

rbenv_execute "load db schema" do
  user 'www-data'
  group 'www-data'
  cwd node[:site_app][:root]
  command "bundle exec rake db:schema:load"
  ruby_version '2.1.3'
end

rbenv_execute "seed db" do
  user 'www-data'
  group 'www-data'
  cwd node[:site_app][:root]
  command "bundle exec rake db:seed"
  ruby_version '2.1.3'
end

rbenv_execute "precompile rails assets" do
  user 'www-data'
  group 'www-data'
  cwd node[:site_app][:root]
  command "bundle exec rake assets:precompile RAILS_ENV=#{ENV['RAILS_ENV']}"
  ruby_version '2.1.3'
end