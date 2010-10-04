desc 'List CloudIPs'
arg_name '[cloudip-id...]'
command [:list] do |c|

  c.action do |global_options,options,args|

    if args.empty?
      ips = Api.conn.list_cloud_ips
    else
      ips = args.collect { |arg| Api.conn.cloud_ips.get arg }
    end

    puts ips.body.inspect

    # Sort
    # ips.sort! { |a,b| a.created_at <=> b.created_at }

    # Filter
    #servers.delete_if do |s|
    #  next true if !options[:d] and s.status == "deleted"
    #  false
    #end

    render_table(ips, :fields => [:id, :status, :type, :image, :created_at, 
                                      :ips, :description], 
                 :flavors => Api.conn.flavors,
                 :global => global_options)
  end
end
