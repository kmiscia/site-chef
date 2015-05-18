#
# Cookbook Name:: site-apache
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

group 'myface'

user 'myface' do
  group 'myface'
  system true
  shell '/bin/bash'
end

include_recipe 'apache2'

apache_site '000-default' do
  enable false
end

template "#{node['apache']['dir']}/sites-available/site.conf" do
  source 'site.conf.erb'
  notifies :restart, 'service[apache2]'
end

apache_site 'site.conf' do
  enable true
end