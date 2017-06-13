#
# Cookbook Name:: site-ruby
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "2.3.0" do
  ruby_version "2.3.0"
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.3.0"
end
