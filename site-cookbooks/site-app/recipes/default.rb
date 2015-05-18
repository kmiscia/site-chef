#
# Cookbook Name:: site-app
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'git'
#include_recipe 'sphinx'

=begin
directory '/apps/site' do
  action :create
  recursive true
end

git "site_app" do
  repository node[:site_app][:repository]
  revision node[:site_app][:version]
  destination node[:site_app][:root]
  action :sync
end
=end

include_recipe "passenger_apache2"

apache_site '000-default' do
  enable false
end

template "#{node['apache']['dir']}/sites-available/site.conf" do
  source 'site.conf.erb'
  notifies :restart, 'service[apache2]'
end

template "#{node['apache']['dir']}/conf-available/other-vhosts-access-log.conf" do
  source "other-vhosts-access-log.conf.erb"
  notifies :restart, 'service[apache2]'
end

apache_site 'site.conf' do
  enable true
end

web_app "site" do
  docroot "#{node[:site_app][:root]}/public"
  server_name "site.#{node[:domain]}"
  server_aliases [ "site", node[:domain] ]
  rails_env "production"
end



