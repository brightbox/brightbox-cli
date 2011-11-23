module Brightbox
  desc 'List servers'
  arg_name '[server-id...]'
  command [:list] do |c|

    c.desc "Group identifier"
    c.flag [:g, :group]

    c.action do |global_options,options,args|
      # Check this here before we make any network connections
      raise "A valid server group identifier is required for the group argument" unless options[:g].nil? || options[:g] =~ /^grp-.{5}$/

      if args.empty?
        servers = Server.find(:all)
      else
        servers = Server.find_or_call(args) do |id|
          warn "Couldn't find server #{id}"
        end
      end

      # Scope by group if a group identifier is specified
      servers = servers.select {|server| server.server_groups.any? {|grp| grp["id"] == options[:g] } } if options[:g]

      render_table(servers, global_options)
    end
  end
end
