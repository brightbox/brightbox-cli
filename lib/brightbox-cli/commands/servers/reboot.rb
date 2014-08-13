module Brightbox
  command [:servers] do |cmd|
    cmd.desc I18n.t("servers.reboot.desc")
    cmd.arg_name "server-id..."
    cmd.command [:reboot] do |c|
      c.desc "Use a hard reset"
      c.switch [:hard]

      c.action do |_global_options, options, args|
        raise "You must specify servers to reboot" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find #{id}"
        end

        servers.each do |server|
          if options[:hard]
            info "Sending reset to #{server}"
            server.reboot(true)
          else
            info "Sending reboot to #{server}"
            server.reboot(false)
          end
        end
      end
    end
  end
end
