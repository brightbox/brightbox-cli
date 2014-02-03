module Brightbox
  command [:servers] do |cmd|

    cmd.desc I18n.t("servers.shutdown.desc")
    cmd.arg_name "server-id..."
    cmd.command [:shutdown] do |c|
      c.action do |global_options, options, args|

        raise "You must specify servers to shutdown" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find server #{id}"
        end

        servers.each do |s|
          info "Shutting down server #{s}"
          s.shutdown
        end

      end
    end
  end
end
