desc 'List servers'
arg_name '[server-id...]'
command [:list] do |c|
  c.desc "Show deleted servers"
  c.switch [:d, "show-deleted"]

  c.action do |global_options,options,args|

    if args.empty?
      servers = Api.conn.servers
    else
      servers = args.collect { |arg| Api.conn.servers.get arg }
    end

    # Sort
    servers.sort! { |a,b| a.created_at <=> b.created_at }

    # Filter
    servers.delete_if do |s|
      next true if !options[:d] and s.status == "deleted"
      false
    end

    render_table(servers, :fields => [:id, :status, :type, :image, :zone, :created_at, 
                                      :ips, :description], 
                 :flavors => Api.conn.flavors,
                 :global => global_options)
  end
end
