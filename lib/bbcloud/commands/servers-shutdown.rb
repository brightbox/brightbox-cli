desc 'Shutdown the specified servers'
arg_name 'server-id...'
command [:shutdown] do |c|
  c.action do |global_options,options,args|

    servers = Server.find(args).compact

    servers.each do |s|
      info "Shutting down server #{s}"
      s.shutdown
      s.reload
    end

    render_table(servers)

  end
end
