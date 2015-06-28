#
# Cookbook Name:: site-resque
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'redis::install_from_package'
include_recipe 'resque'

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