#
# Cookbook Name:: site-thinking-sphinx
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
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

# Actually not sure if this is still needed?
mysql_service 'sphinx_mysql_service' do
  port '3306'
  # The latest version supported on Ubuntu 12.04 
  # by this cookbook is 5.5
  version '5.5' 
  initial_root_password 'changeme'
  action [:create, :start]
end

rbenv_execute "build thinking sphinx indexes" do
  user 'www-data'
  group 'www-data'
  cwd node[:site_app][:root]
  command "bundle exec rake ts:rebuild RAILS_ENV=#{ENV['RAILS_ENV']}"
  ruby_version '2.1.3'
end

include_recipe 'cron'

cron_d 'reindex_sphinx' do
  minute node[:sphinx][:reindex_minute]
  hour node[:sphinx][:reindex_hour]
  command "cd #{node[:site_app][:root]} && bundle exec rake ts:rebuild RAILS_ENV=#{ENV['RAILS_ENV']}"
  user 'www-data'
end