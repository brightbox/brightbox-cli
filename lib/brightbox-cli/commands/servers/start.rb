module Brightbox
  command [:servers] do |cmd|
    cmd.desc I18n.t("servers.start.desc")
    cmd.arg_name "server-id..."
    cmd.command [:start] do |c|
      c.action do |_global_options, _options, args|
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
end
