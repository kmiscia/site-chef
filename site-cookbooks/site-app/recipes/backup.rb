rbenv_execute "install backup gem" do
  command "gem install backup"
  ruby_version '2.1.3'
end

# Because the backup gem has one million dependencies that
# would all be loaded into your apps memory, it's recommended
# back and it's gems be installed seperately.
['net-scp', 'net-ssh', 'fog', 'excon'].each do |gem_dependency|
  rbenv_execute "install backup gem dependencies" do
    command "backup dependencies --install #{gem_dependency}"
    ruby_version '2.1.3'
  end
end

include_recipe 'cron'

cron_d 'site_app_backup' do
  minute node[:backup][:minute]
  hour node[:backup][:hour]
  command "APP_ROOT=#{node[:site_app][:root]} /opt/rbenv/shims/backup perform -t #{node[:backup][:model]} -c #{node[:site_app][:root]}/backup/config.rb"
  user 'root'
end

