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

execute "decrypt secrets.yml" do
  cwd node[:site_app][:root]
  command "#{node[:ruby][:dir]}/bin/bundle exec rake secrets:decrypt"
  user 'www-data'
  group 'www-data'
end