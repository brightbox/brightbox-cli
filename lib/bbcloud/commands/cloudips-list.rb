desc 'List CloudIPs'
arg_name '[cloudip-id...]'
command [:list] do |c|

  c.action do |global_options,options,args|

    ips = CloudIP.find args

    render_table(ips.sort, global_options)
  end
end
