module Brightbox
  desc 'List servers'
  arg_name '[server-id...]'
  command [:list] do |c|
    c.action do |global_options,options,args|
      if args.empty?
        servers = Server.find(:all)
      else
        servers = Server.find_or_call(args) do |id|
          warn "Couldn't find server #{id}"
        end
      end
      render_table(servers, global_options)
    end
  end
end
