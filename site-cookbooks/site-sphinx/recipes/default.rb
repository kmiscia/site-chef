#
# Cookbook Name:: site-sphinx
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'sphinx'

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

execute "build the sphinx indexes" do
  cwd node[:site_app][:root]
  user 'www-data'
  group 'www-data'
  command "#{node[:ruby][:dir]}/bin/bundle exec rake ts:rebuild RAILS_ENV=#{ENV['RAILS_ENV']}"
end