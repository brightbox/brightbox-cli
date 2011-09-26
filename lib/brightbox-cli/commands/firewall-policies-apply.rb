module Brightbox
  desc 'Apply firewall policy to a server group'
  arg_name '[firewall-policy-id...]'

  command [:apply] do |c|
    c.desc 'Server Group id'
    c.flag [:g, :group]

    c.action do |global_options, options,args|
      if args && args.empty?
        raise "You must specify the firewall_policy_id as the first argument"
      end
      firewall_policy_id = args.shift
      firewall_policy = FirewallPolicy.find(firewall_policy_id)

      unless firewall_policy
        raise "Could not find firewall policy with #{firewall_policy_id}"
      end
      unless options[:g]
        raise "You must specify server group to which the policy will be applied"
      end

      server_group = ServerGroup.find(options[:g])
      unless server_group
        raise "Can\'t find group with #{options[:g]}"
      end
      firewall_policy.apply_to(server_group.id)
      render_table([firewall_policy],global_options)
    end
  end
end
