module Brightbox
  command [:servers] do |cmd|

    cmd.default_command :list

    cmd.desc "List servers"
    cmd.arg_name "[server-id...]"
    cmd.command [:list] do |c|

      c.desc "Group identifier"
      c.flag [:g, :group]

      c.action do |global_options, options, args|
        # Check this here before we make any network connections
        raise "A valid server group identifier is required for the group argument" unless options[:g].nil? || options[:g] =~ /^grp-.{5}$/
        servers = Server.find_all_or_warn(args)

        # Scope by group if a group identifier is specified
        servers = servers.select {|server| server.server_groups.any? {|grp| grp["id"] == options[:g] } } if options[:g]

        render_table(servers, global_options)
      end
    end
  end
end
