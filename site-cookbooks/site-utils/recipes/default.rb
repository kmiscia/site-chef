#
# Cookbook Name:: site-utils
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'site-utils::users'