desc 'Snapshot the specified servers'
arg_name 'server-id...'
command [:snapshot] do |c|

  c.action do |global_options,options,args|

    raise "You must specify servers to snapshot" if args.empty?

    servers = Server.find_or_call(args) do |id|
      raise "Couldn't find server #{id}"
    end

    servers.each do |s|
      info "Snapshotting server #{s}"
      s.snapshot
    end

  end
end
