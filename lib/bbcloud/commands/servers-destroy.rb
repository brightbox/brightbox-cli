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
      raise "Server #{sid} does not exist" if server.nil?
      begin
        server.destroy
      rescue Brightbox::Api::Conflict => e
        error "Could not destroy #{sid}"
      end
      server.reload
      server
    end

    render_table(servers, global_options)
  end
end
