module Brightbox
  command [:servers] do |cmd|

    cmd.desc I18n.t("servers.snapshot.desc")
    cmd.arg_name "server-id..."
    cmd.command [:snapshot] do |c|

      c.action do |_global_options, _options, args|

        raise "You must specify servers to snapshot" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find server #{id}"
        end

        servers.each do |s|
          info "Snapshotting server #{s}"
          s.snapshot
        end

      end
    end
  end
end
