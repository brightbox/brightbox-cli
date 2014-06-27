module Brightbox
  command [:servers] do |cmd|

    cmd.desc I18n.t("servers.destroy.desc")
    cmd.arg_name "[server-id...]"
    cmd.command [:destroy] do |c|
      c.action do |_global_options, _options, args|

        raise "You must specify servers to destroy" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find server #{id}"
        end

        servers.each do |server|
          info "Destroying server #{server}"
          begin
            server.destroy
          rescue Brightbox::Api::Conflict
            error "Could not destroy #{server}"
          end
        end

      end
    end
  end
end
