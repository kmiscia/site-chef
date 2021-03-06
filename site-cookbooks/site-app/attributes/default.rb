default[:ruby][:dir] = "/opt/rbenv/versions/2.3.0/"
default[:ruby][:version] = "2.3.0"

default[:site_app][:root] = "/apps/site"
default[:site_app][:repository] = 'git://github.com/kmiscia/site2.git'
default[:site_app][:version] = 'master'
default[:site_app][:environment] = 'production'
default[:site_app][:encryption_key_location] = "/home/vagrant"

default[:backup][:model] = 'misciadotnetbackup'
default[:backup][:hour] = 3
default[:backup][:minute] = 0

default[:passenger][:version] = '4.0.14'
default[:passenger][:ruby_bin] = "#{node[:ruby][:dir]}/bin/ruby"
default[:passenger][:root_path] = "#{node[:ruby][:dir]}/lib/ruby/gems/2.3.0/gems/passenger-#{node[:passenger][:version]}"

default[:rails][:version] = '4.2.7.1'
