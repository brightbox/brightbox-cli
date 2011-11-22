module Brightbox
  desc 'Add servers to a server group'
  arg_name 'grp-id [srv-id...]'
  command [:add_servers] do |c|

    c.action do |global_options, options, args|
      grp_id = args.shift
      raise "You must specify the server group and then the server ids to add" unless grp_id && grp_id[/^grp-/] && !args.empty?

      sg = ServerGroup.find grp_id

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      info "Adding #{servers.size} servers to server group #{sg}"
      sg.add_servers servers
      sg.reload
      render_table([sg], global_options)
    end

  end
end
