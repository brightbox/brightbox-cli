module Brightbox
  command [:groups] do |cmd|
    cmd.desc I18n.t("groups.move_servers.desc")
    cmd.arg_name "srv-id ..."
    cmd.command [:move_servers] do |c|
      c.desc "Source Server Group"
      c.flag %i[f from]

      c.desc "Target Server Group"
      c.flag %i[t to]

      c.action do |global_options, options, args|
        unless args && !args.empty?
          raise "You must specify server ids to move"
        end

        source_id = options[:f]
        destination_id = options[:t]

        unless source_id && source_id[/^grp-/] && destination_id && destination_id[/^grp-/]
          raise "You must specify the source server group and destination server group"
        end

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
end
