default[:site_app][:root] = "/apps/site"
default[:site_app][:repository] = 'git://github.com/kmiscia/site2.git'
default[:site_app][:version] = 'master'

default[:passenger][:version] = '4.0.14'
default[:passenger][:ruby_bin] = languages['ruby']['ruby_bin']
default[:passenger][:root_path] = "/opt/rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.14"

default[:apache][:log_dir] = "/var/log/apache2"