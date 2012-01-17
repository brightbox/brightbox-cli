module Brightbox
  desc 'Activate the console service for one or more servers'
  arg_name 'server-id...'
  command [:activate_console] do |c|

    c.action do |global_options,options,args|

      raise "You must specify servers to activate the console for" if args.empty?

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      consoles = []

      servers.each do |s|
        info "Activating console for server #{s}"
        r = s.activate_console
        url = "#{r["console_url"]}/?password=#{r["console_token"]}"
        consoles << { :url => url, :token => r["console_token"], :expires => r["console_token_expires"] }
      end

      render_table(consoles, global_options.merge(:fields => [:url, :token, :expires]))
    end
  end
end
