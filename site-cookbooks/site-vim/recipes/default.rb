#
# Cookbook Name:: site-vim
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'vim'

link "/usr/bin/vi" do
  to "/usr/bin/vim"
end