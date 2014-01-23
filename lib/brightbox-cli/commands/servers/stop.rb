module Brightbox
  command [:servers] do |cmd|

    cmd.desc "Stop the specified servers, aka turning the power off"
    cmd.arg_name "server-id..."
    cmd.command [:stop] do |c|

      c.action do |global_options, options, args|

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
end
