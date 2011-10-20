module Brightbox
  desc 'Stop the specified servers, aka turning the power off'
  arg_name 'server-id...'
  command [:stop] do |c|

    c.action do |global_options,options,args|

      raise "You must specify servers to stop" if args.empty?

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      servers.each do |s|
        info "Stopping server #{s}"
        s.stop
      end
    end
  end
end
