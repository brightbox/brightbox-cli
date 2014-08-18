module Brightbox
  command [:servers] do |cmd|
    cmd.desc I18n.t("servers.reset.desc")
    cmd.arg_name "server-id..."
    cmd.command [:reset] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify servers to reset" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find #{id}"
        end

        servers.each do |server|
          info "Sending reset to #{server}"
          server.reboot(true)
        end
      end
    end
  end
end
