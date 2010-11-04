desc 'List servers'
arg_name '[server-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

    Type.cache_all!
    Zone.cache_all!

    servers = Server.find(args).compact

    render_table(servers, global_options)
  end
end
