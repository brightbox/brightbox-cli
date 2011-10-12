module Brightbox
  desc 'Show detailed server info'
  arg_name 'server-id...'
  command [:show] do |c|

    c.action do |global_options,options,args|

      raise "You must specify servers to show" if args.empty?

      servers = DetailedServer.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      table_opts = global_options.merge(:vertical => true)
      render_table(servers, table_opts)
    end
  end
end
