require 'json'

define :render_config_template, category:nil, parameter: {} do
  params = self.params

  tparams = {}
  params[:parameter].to_hash.each do |key, value|
    next if key == "filepath" || key == "action"
    tparams[key] = value if value
  end

  render_param = {}
  if params[:category]
    render_param = { "#{params[:category]}" => tparams }
  else
    render_param = tparams
  end

  template params[:parameter]["filepath"] do
    source File.expand_path(File.dirname(__FILE__)) + "/config.json.erb"
    variables(json: JSON.pretty_generate(render_param) )
    mode "644"
  end
end

define :consul_config,
    acl_datacenter: nil,
    acl_default_policy: nil,
    acl_down_policy: nil,
    acl_master_token: nil,
    acl_token: nil,
    acl_ttl: nil,
    addresses: nil,
    advertise_addr: nil,
    atlas_acl_token: nil,
    atlas_infrastructure: nil,
    atlas_join: nil,
    atlas_token: nil,
    bootstrap: nil,
    bootstrap_expect: nil,
    bind_addr: nil,
    ca_file: nil,
    cert_file: nil,
    check_update_interval: nil,
    client_addr: nil,
    datacenter: nil,
    data_dir: nil,
    disable_anonymous_signature: nil,
    disable_remote_exec: nil,
    disable_update_check: nil,
    dns_config: nil,
    domain: nil,
    enable_debug: nil,
    enable_syslog: nil,
    encrypt: nil,
    key_file: nil,
    leave_on_terminate: nil,
    log_level: nil,
    node_name: nil,
    ports: nil,
    protocol: nil,
    recursor: nil,
    rejoin_after_leave: nil,
    retry_join: nil,
    retry_interval: nil,
    server: nil,
    server_name: nil,
    skip_leave_on_interrupt: nil,
    start_join: nil,
    statsd_addr: nil,
    statsite_addr: nil,
    syslog_facility: nil,
    ui_dir: nil,
    verify_incoming: nil,
    verify_outgoing: nil,
    watches: nil do

  params = self.params
  params[:filepath] = params[:name]
  params.delete(:name)
  render_config_template "render template" do
    parameter params.to_hash()
  end
end

define :consul_check_config,
    id: nil,
    check_name: nil,
    script: nil,
    interval: nil,
    service_id: nil,
    http: nil,
    notes: nil,
    timeout: nil,
    ttl: nil do

  params = self.params
  params[:filepath] = params[:name]
  params[:name] = params.delete(:check_name)
  render_config_template "render template" do
    category  "check"
    parameter params.to_hash()
  end
end

define :consul_service_config,
    service_name: nil,
    tags: nil,
    port: nil,
    check: nil do

  params = self.params
  params[:filepath] = params[:name]
  params[:name] = params.delete(:service_name)
  render_config_template "render template" do
    category  "service"
    parameter params.to_hash()
  end
end
