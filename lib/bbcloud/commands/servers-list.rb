desc 'List servers'
arg_name '[server-id...]'
command [:list] do |c|
  c.desc "Show deleted servers"
  c.switch [:d, "show-deleted"]

  c.action do |global_options,options,args|

    servers = Server.find args

    # Filter
    servers.delete_if do |s|
      next true if !options[:d] and s.deleted?
      false
    end

    render_table(servers, global_options)
  end
end
