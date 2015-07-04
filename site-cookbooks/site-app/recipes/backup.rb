execute "install backup" do
  command "/opt/rbenv/shims/gem install backup"
end

# Because the backup gem has one million dependencies that
# would all be loaded into your apps memory, it's recommended
# back and it's gems be installed seperately.
execute "install backup gem" do
  ['net-scp', 'net-ssh', 'fog', 'excon'].each do |gem_dependency|
    command "backup dependencies --install #{gem_dependency}"
  end
end