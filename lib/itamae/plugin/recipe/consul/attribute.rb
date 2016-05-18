node['consul'] = {} unless node['consul']

# vers
node['consul']['version']             = node['consul']['version'] || "0.5.2"
node['consul']['binary_baseurl']      = node['consul']['binary_baseurl'] || "https://releases.hashicorp.com/consul"
node['consul']['binary_url']          = node['consul']['binary_url'] || "#{node['consul']['binary_baseurl']}/#{node['consul']['version']}/consul_#{node['consul']['version']}_linux_amd64.zip"
node['consul']['log_dir']             = node['consul']['log_dir'] || '/var/log/consul'
node['consul']['install_dir']         = node['consul']['install_dir'] || '/usr/local/bin'
node['consul']['data_dir']            = node['consul']['data_dir'] || '/var/lib/consul'
node['consul']['config_dir']          = node['consul']['config_dir'] || '/etc/consul.d'

# server
node['consul']['server']              = node['consul']['server'] || false

# server ui
node['consul']['webui_binary_url']    = node['consul']['webui_binary_url'] || "#{node['consul']['binary_baseurl']}/#{node['consul']['version']}/consul_#{node['consul']['version']}_web_ui.zip"
node['consul']['webui']               = node['consul']['webui']

# client
node['consul']['start_join']          = node['consul']['start_join'] || []

# consul-template
node['consul']['template']               = node['consul']['template']
node['consul']['template_version']       = node['consul']['template_version'] || '0.11.1'
node['consul']['template_binary_url']    = node['consul']['template_binary_url'] || "https://releases.hashicorp.com/consul-template/#{node['consul']['template_version']}/consul-template_#{node['consul']['template_version']}_linux_amd64.zip"
