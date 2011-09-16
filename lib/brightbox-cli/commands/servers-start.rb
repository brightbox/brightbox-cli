module Brightbox
  desc 'Start the specified servers'
  arg_name 'server-id...'
  command [:start] do |c|

    c.action do |global_options,options,args|

      raise "You must specify servers to start" if args.empty?

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      servers.each do |s|
        info "Starting server #{s}"
        s.start
      end

    end
  end
end
