module Brightbox
  desc 'Move servers from one server group to another'
  arg_name 'grp-id grp-id [srv-id...]'
  command [:move_servers] do |c|

    c.action do |global_options, options, args|
      source_id = args.shift
      destination_id = args.shift
      raise "You must specify the source server group, destination server group and the server ids to remove" unless source_id && source_id[/^grp-/] && destination_id && destination_id[/^grp-/] && !args.empty?

      source_group = ServerGroup.find source_id
      destination_group = ServerGroup.find destination_id

      servers = Server.find_or_call(args) do |id|
        raise "Couldn't find server #{id}"
      end

      info "Moving #{servers.size} servers from server group #{source_group} to server group #{destination_group}"
      source_group.move_servers servers, destination_group
      source_group.reload
      destination_group.reload
      render_table([source_group, destination_group], global_options)
    end

  end
end
