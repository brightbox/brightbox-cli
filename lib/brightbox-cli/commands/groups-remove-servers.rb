module Brightbox
  desc 'Remove servers from a server group'
  arg_name 'grp-id [srv-id...]'
  command [:remove_servers] do |c|

    c.action do |global_options, options, args|
      grp_id = args.shift
      raise "You must specify the server group and the server ids to remove" unless grp_id && grp_id[/^grp-/] && !args.empty?

      sg = ServerGroup.find grp_id

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      info "Removing #{servers.size} servers from server group #{sg}"
      sg.remove_servers servers
      sg.reload
      render_table([sg], global_options)
    end

  end
end
