desc 'Stop the specified servers'
arg_name 'server-id...'
command [:stop] do |c|

  c.action do |global_options,options,args|
    
    servers = Server.find(args).compact

    servers.each do |s|
      info "Stopping server #{s}"
      s.stop
      s.reload
    end

    render_table(servers)

  end
end
