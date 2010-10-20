desc 'Start the specified servers'
arg_name 'server-id...'
command [:start] do |c|

  c.action do |global_options,options,args|
    
    servers = Server.find(args).compact

    servers.each do |s|
      info "Starting server #{s}"
      s.start
      s.reload
    end

    render_table(servers)

  end
end
