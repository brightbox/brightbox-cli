desc 'Destroy servers'
arg_name '[server-id...]'
command [:destroy] do |c|
  c.action do |global_options, options, args|

    if args.empty?
      raise "you must specify the id of the server(s) you want to destroy"
    end


    servers = args.collect do |sid|
      info "Destroying server #{sid}"
      server = Server.find sid
      server.destroy
      server.reload
    end

    render_table(servers, :fields => [:id, :status, :type, :image, :created_at, 
                                      :ips, :description],
                 :global => global_options)
  end
end
