default[:ruby][:dir] = "/opt/rbenv/versions/2.1.3/"

default[:site_app][:root] = "/apps/site"
default[:site_app][:repository] = 'git://github.com/kmiscia/site2.git'
default[:site_app][:version] = 'master'
default[:site_app][:environment] = 'production'

default[:passenger][:version] = '4.0.14'
default[:passenger][:ruby_bin] = "#{node[:ruby][:dir]}/bin/ruby"
default[:passenger][:root_path] = "#{node[:ruby][:dir]}/lib/ruby/gems/2.1.0/gems/passenger-#{node[:passenger][:version]}"

default[:sphinx][:use_mysql] = true
default[:sphinx][:use_postgres] = true