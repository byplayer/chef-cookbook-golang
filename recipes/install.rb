
bash "install-golang" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf go
    rm -rf /usr/local/go
    tar -C /usr/local -xzf #{node["go"]["filename"]}
  EOH
  action :nothing
end

remote_file File.join(Chef::Config[:file_cache_path], node['go']['filename']) do
  source node['go']['url']
  owner "root"
  mode 0644
  notifies :run, "bash[install-golang]", :immediately
  not_if "/usr/local/go/bin/go version | grep #{node['go']['version']}"
end

cookbook_file "/etc/profile.d/golang.sh" do
  source "golang.sh"
  owner "root"
  group "root"
  mode 0755
end
