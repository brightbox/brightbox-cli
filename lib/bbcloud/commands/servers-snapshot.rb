desc 'Snapshot the specified servers'
arg_name 'server-id...'
command [:snapshot] do |c|

  c.action do |global_options,options,args|

    servers = Server.find(args).compact

    servers.each do |s|
      info "Snapshotting server #{s}"
      s.snapshot
    end

    render_table(servers)

  end
end
