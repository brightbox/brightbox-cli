module Brightbox
  command [:"firewall-policies"] do |cmd|
    cmd.desc I18n.t("firewall.policies.create.desc")
    cmd.arg_name "[server-group-id...]"
    cmd.command [:create] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.action do |global_options, options, args|
        server_group_id = nil
        server_group = nil

        unless args.empty?
          server_group_id = args.shift
        end

        if server_group_id && !server_group_id.empty?
          server_group = ServerGroup.find(server_group_id)
        end

        name = options[:n]
        description = options[:d]

        firewall_options = {
          :name => name, :description => description
        }

        if server_group
          firewall_options.update(:server_group_id => server_group.id)
        end

        firewall_policy = FirewallPolicy.create(firewall_options)
        render_table([firewall_policy], global_options)
      end
    end
  end
end
