node['consul'] = {} unless node['consul']

# vers
node['consul']['version']             = node['consul']['version'] || "0.4.1"
node['consul']['binary_baseurl']      = node['consul']['binary_baseurl'] || "https://dl.bintray.com/mitchellh/consul"
node['consul']['binary_url']          = node['consul']['binary_url'] || "#{node['consul']['binary_url']}/#{node['consul']['version']}_linux_amd64.zip"
node['consul']['log_dir']             = node['consul']['log_dir'] || '/var/log/consul'
node['consul']['install_dir']         = node['consul']['install_dir'] || '/usr/local/bin'
node['consul']['data_dir']            = node['consul']['data_dir'] || '/var/lib/consul'
node['consul']['config_dir']          = node['consul']['config_dir'] || '/etc/consul.d'

# server
node['consul']['server']              = node['consul']['server'] || false

# server ui
node['consul']['webui_binary_url']    = node['consul']['webui_binary_url'] || "#{node['consul']['binary_url']}/#{node['consul']['version']}_web_ui.zip"
node['consul']['webui']               = node['consul']['webui']

# client
node['consul']['start_join']          = node['consul']['start_join'] || []




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

template "/etc/init.d/consul" do
  source File.expand_path(File.dirname(__FILE__)) + "/consul.init.erb"
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

service "consul" do
  action :enable
end
