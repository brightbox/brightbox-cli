desc 'show details on Cloud IPs'
arg_name 'cloudip-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    ips = CloudIP.find args

    fields = [:id, :status, :public_ip, :reverse_dns, :server_id, :interface_id]

    render_table(ips.compact, global_options.merge({ :vertical => true, :fields => fields}))                                              
  end
end
