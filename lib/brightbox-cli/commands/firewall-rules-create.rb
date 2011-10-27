module Brightbox
  desc 'Create Firewall Rule'
  arg_name '[firewall-policy-id...]'

  command [:create] do |c|
    c.desc "Protocol - [tcp/udp/icmp/Protocol numbers]"
    c.flag [:p, :protocol]

    c.desc "Source - IPv4/IPv6 address or range (CIDR notation), 'any' for combined IPv4/IPv6 wildcard, server group identifer, server identifier."
    c.flag [:s, :source]

    c.desc "Source Port"
    c.flag [:t, :sport]

    c.desc "Destination. IPv4/IPv6 address or range (CIDR notation), 'any' for combined IPv4/IPv6 wildcard, server group identifer, server identifier."
    c.flag [:d, :destination]

    c.desc "Destination Port"
    c.flag [:e, :dport]

    c.desc "Icmp Type name"
    c.flag [:i, :icmptype]

    c.action do |global_options, options, args|
      if args && args.empty?
        raise "You must specify the firewall_policy_id as the first argument"
      end

      firewall_policy_id = args.shift
      raise "Invalid firewall policy id" unless firewall_policy_id[/^fwp-/]

      firewall_policy = FirewallPolicy.find(firewall_policy_id)

      unless firewall_policy
        raise "Could not find firewall policy with #{firewall_policy_id}"
      end

      create_options = {}
      create_options[:source_port] = options[:t] if options[:t]
      create_options[:source] = options[:s] if options[:s]
      create_options[:destination] = options[:d] if options[:d]
      create_options[:destination_port] = options[:e] if options[:e]
      create_options[:icmp_type_name] = options[:i] if options[:i]
      create_options[:protocol] = options[:p]

      create_options[:firewall_policy_id] = firewall_policy.id
      firewall_rule = FirewallRule.create(create_options)
      render_table([firewall_rule],global_options)
    end
  end
end
