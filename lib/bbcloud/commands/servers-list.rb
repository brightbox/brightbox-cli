desc 'List servers'
arg_name '[server-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

    servers = Server.find(args).compact

    render_table(servers, global_options)
  end
end
