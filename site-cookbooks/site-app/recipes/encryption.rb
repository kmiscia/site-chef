file "#{node[:site_app][:root]}/config/encryption/site_production.iv" do
  content File.open(File.join(node[:site_app][:encryption_key_location], 'site_production.iv')).read
  mode '0644'
  owner 'www-data'
  group 'www-data'
end

file "#{node[:site_app][:root]}/config/encryption/site_production.key" do
  content File.open(File.join(node[:site_app][:encryption_key_location], 'site_production.key')).read
  mode '0644'
  owner 'www-data'
  group 'www-data'
end

rbenv_execute "decrypt secrets" do
  user 'www-data'
  group 'www-data'
  cwd node[:site_app][:root]
  command "bundle exec rake secrets:decrypt"
  ruby_version '2.3.0'
end