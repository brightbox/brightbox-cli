module Brightbox
  command [:servers] do |cmd|
    cmd.desc "Show detailed server info"
    cmd.arg_name "server-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        servers = DetailedServer.find_all_or_warn(args)

        table_opts = global_options.merge(:vertical => true)
        render_table(servers, table_opts)
      end
    end
  end
end
