include_recipe './attribute.rb'


# create user
user "consul" do
  action :create
end
execute "disable user shell" do
  command "usermod -s /sbin/nologin consul"
end

# directory
directory node['consul']['log_dir'] do
  action :create
  owner "consul"
end
directory node['consul']['config_dir'] do
  action :create
  owner "consul"
end
directory node['consul']['data_dir'] do
  action :create
  owner "consul"
end

# install consul
execute "install consul" do
  command <<-"EOH"
cd /tmp
curl -L -O #{node['consul']['binary_url']}
unzip #{node['consul']['version']}_linux_amd64.zip
mv ./consul #{node['consul']['install_dir']}/consul
EOH
  not_if "test -e #{node['consul']['install_dir']}/consul && consul --version | grep -q 'v#{node['consul']['version']}'"
end

ui_dir = nil
# install webui
if node['consul']['server'] && node['consul']['webui'] then
  ui_dir = "#{node['consul']['data_dir']}/ui"
  execute "install consul ui" do
    command <<-"EOH"
cd /tmp
curl -L -O #{node['consul']['webui_binary_url']}
unzip #{node['consul']['version']}_web_ui.zip
mv ./dist #{ui_dir}
EOH
    not_if "test -e #{ui_dir}"
  end
end

# install consul template
if node['consul']['template'] then
  execute "install consul template" do
    command <<-"EOH"
cd /tmp
curl -L -O #{node['consul']['template_binary_url']}
tar zxvf consul-template_#{node['consul']['template_version']}_linux_amd64.tar.gz
mv ./consul-template_#{node['consul']['template_version']}_linux_amd64/consul-template #{node['consul']['install_dir']}/consul-template
EOH
    not_if "test -e #{node['consul']['install_dir']}/consul-template"
  end
end

template "/etc/init.d/consul" do
  source File.expand_path(File.dirname(__FILE__)) + "/initscript.erb"
  variables(node['consul'])
  mode "755"
end


include_recipe "./resource.rb"

consul_config "#{node['consul']['config_dir']}/consul.json" do
  acl_datacenter               node['consul']['acl_datacenter']
  acl_default_policy           node['consul']['acl_default_policy']
  acl_down_policy              node['consul']['acl_down_policy']
  acl_master_token             node['consul']['acl_master_token']
  acl_token                    node['consul']['acl_token']
  acl_ttl                      node['consul']['acl_ttl']
  atlas_acl_token              node['consul']['atlas_acl_token']
  atlas_infrastructure         node['consul']['atlas_infrastructure']
  atlas_join                   node['consul']['atlas_join']
  atlas_token                  node['consul']['atlas_token']
  addresses                    node['consul']['addresses']
  advertise_addr               node['consul']['advertise_addr']
  bootstrap                    node['consul']['bootstrap']
  bootstrap_expect             node['consul']['bootstrap_expect']
  bind_addr                    node['consul']['bind_addr']
  ca_file                      node['consul']['ca_file']
  cert_file                    node['consul']['cert_file']
  check_update_interval        node['consul']['check_update_interval']
  client_addr                  node['consul']['client_addr']
  datacenter                   node['consul']['datacenter']
  data_dir                     node['consul']['data_dir']
  disable_anonymous_signature  node['consul']['disable_anonymous_signature']
  disable_remote_exec          node['consul']['disable_remote_exec']
  disable_update_check         node['consul']['disable_update_check']
  dns_config                   node['consul']['dns_config']
  domain                       node['consul']['domainname'] # avoid host_inventory
  enable_debug                 node['consul']['enable_debug']
  enable_syslog                node['consul']['enable_syslog']
  encrypt                      node['consul']['encrypt']
  key_file                     node['consul']['key_file']
  leave_on_terminate           node['consul']['leave_on_terminate']
  log_level                    node['consul']['log_level']
  node_name                    node['consul']['node_name']
  ports                        node['consul']['ports']
  protocol                     node['consul']['protocol']
  recursor                     node['consul']['recursor']
  rejoin_after_leave           node['consul']['rejoin_after_leave']
  retry_join                   node['consul']['retry_join']
  retry_interval               node['consul']['retry_interval']
  server                       node['consul']['server']
  server_name                  node['consul']['server_name']
  skip_leave_on_interrupt      node['consul']['skip_leave_on_interrupt']
  start_join                   node['consul']['start_join']
  statsd_addr                  node['consul']['statsd_addr']
  statsite_addr                node['consul']['statsite_addr']
  syslog_facility              node['consul']['syslog_facility']
  ui_dir                       ui_dir
  verify_incoming              node['consul']['verify_incoming']
  verify_outgoing              node['consul']['verify_outgoing']
  watches                      node['consul']['watches']
end
