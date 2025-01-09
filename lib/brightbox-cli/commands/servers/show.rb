module Brightbox
  command [:servers] do |cmd|
    cmd.desc "Show detailed server info"
    cmd.arg_name "server-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        raise "You must specify server IDs to show" if args.empty?

        servers = DetailedServer.find_or_call(args) do |id|
          raise "Couldn't find a server with ID #{id}"
        end

        table_opts = global_options.merge(:vertical => true)
        render_table(servers, table_opts)
      end
    end
  end
end
