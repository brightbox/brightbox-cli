module Brightbox
  command [:groups] do |cmd|
    cmd.desc I18n.t("groups.remove_servers.desc")
    cmd.arg_name "grp-id [srv-id...]"
    cmd.command [:remove_servers] do |c|
      c.desc "Remove all servers from group"
      c.switch %i[a all], :negatable => false

      c.action do |global_options, options, args|
        grp_id = args.shift
        raise "You must specify the server group and the server ids to remove" unless grp_id && grp_id[/^grp-/] && (!args.empty? || options[:a])

        sg = ServerGroup.find grp_id

        servers = if options[:a]
                    sg.server_ids
                  else
                    Server.find_or_call(args) do |id|
                      raise "Couldn't find server #{id}"
                    end
                  end

        if servers.empty?
          info "Server group #{sg} already contains zero servers"
        else
          info "Removing#{' all' if options[:a]} #{servers.size} servers from server group #{sg}"
          sg.remove_servers servers
        end

        sg.reload
        render_table([sg], global_options)
      end
    end
  end
end
