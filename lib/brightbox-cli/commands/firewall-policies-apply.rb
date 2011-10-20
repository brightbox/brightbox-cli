module Brightbox
  desc 'Apply firewall policy to a server group'
  arg_name 'firewall-policy-id server-group-id'

  command [:apply] do |c|
    c.action do |global_options, options,args|
      if args.size != 2
        raise "You must specify firewall_policy_id and server_group_id as arguments"
      end

      firewall_policy_id = args.shift
      raise "Invalid firewall policy id" unless firewall_policy_id[/^fwp-/]
      server_group_id = args.shift
      raise "Invalid Server Group id" unless server_group_id[/^grp-/]

      firewall_policy = FirewallPolicy.find(firewall_policy_id)

      unless firewall_policy
        raise "Could not find firewall policy with #{firewall_policy_id}"
      end


      server_group = ServerGroup.find(server_group_id)
      unless server_group
        raise "Can\'t find group with #{options[:g]}"
      end
      firewall_policy.apply_to(server_group.id)
      render_table([firewall_policy],global_options)
    end
  end
end
