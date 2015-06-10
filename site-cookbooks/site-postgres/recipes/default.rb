#
# Cookbook Name:: site-postgres
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'

execute "create new postgres user" do
  user "postgres"
  command "PGPASSWORD=50ce1017bb2e1ec822fbe3eea2cfad1d psql -c \"create user #{node['postgresql']['user']['name']} with password '#{node['postgresql']['user']['password']}';\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_roles WHERE rolname='#{node['postgresql']['user']['name']}'\" | wc -l`.chomp == "1" }
end

execute "create new postgres database" do
  user "postgres"
  command "PGPASSWORD=50ce1017bb2e1ec822fbe3eea2cfad1d psql -c \"create database #{node['postgresql']['database']} owner #{node['postgresql']['user']['name']};\""
  not_if { `sudo -u postgres psql -tAc \"SELECT * FROM pg_database WHERE datname='#{node['postgresql']['database']}'\" | wc -l`.chomp == "1" }
end

=begin
postgresql_connection_info = {
  :host     => '127.0.0.1',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database node['postgresql']['database'] do
  connection postgresql_connection_info
  action     :create
end

postgresql_database_user node['postgresql']['user']['name'] do
  connection postgresql_connection_info
  password node['postgresql']['user']['password']
  action :create
end

postgresql_database_user node['postgresql']['user']['name'] do
  connection postgresql_connection_info
  database_name node['postgresql']['database']
  privileges [:all]
  action :grant
end
=end