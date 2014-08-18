module Brightbox
  command [:servers] do |cmd|
    cmd.desc I18n.t("servers.lock.desc")
    cmd.arg_name "[server-id...]"
    cmd.command [:lock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify server as arguments" if args.empty?

        servers = Server.find_or_call(args) do |server|
          raise "Couldn't find #{server}"
        end

        servers.each do |server|
          info "Locking #{server}"
          server.lock!
        end
      end
    end

    cmd.desc I18n.t("servers.unlock.desc")
    cmd.arg_name "[server-id...]"
    cmd.command [:unlock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify servers as arguments" if args.empty?

        servers = Server.find_or_call(args) do |server|
          raise "Couldn't find #{server}"
        end

        servers.each do |server|
          info "Unlocking #{server}"
          server.unlock!
        end
      end
    end
  end
end
