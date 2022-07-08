module Brightbox
  command [:"firewall-rules"] do |cmd|
    cmd.desc I18n.t("firewall.rules.update.desc")
    cmd.arg_name "[firewall-rule-id...]"
    cmd.command [:update] do |c|
      c.desc "Protocol - [tcp/udp/icmp/Protocol numbers]"
      c.flag %i[p protocol]

      c.desc "Source - IPv4/IPv6 address or range (CIDR notation), 'any' for combined IPv4/IPv6 wildcard, server group identifer, server identifier."
      c.flag %i[s source]

      c.desc "Source Port"
      c.flag %i[t sport]

      c.desc "Destination. IPv4/IPv6 address or range (CIDR notation), 'any' for combined IPv4/IPv6 wildcard, server group identifer, server identifier."
      c.flag %i[d destination]

      c.desc "Destination Port"
      c.flag %i[e dport]

      c.desc "Icmp Type name"
      c.flag %i[i icmptype]

      c.desc I18n.t("options.description.desc")
      c.flag :description

      c.action do |global_options, options, args|
        fwr_id = args.shift
        raise "You must specify a valid firewall rule id as the first argument" unless fwr_id =~ /^fwr-/

        firewall_rule = FirewallRule.find fwr_id
        raise "Could not find firewall rule with #{firewall_rule_id}" unless firewall_rule

        params = NilableHash.new
        params[:source_port]      = options[:t] if options[:t]
        params[:source]           = options[:s] if options[:s]
        params[:destination]      = options[:d] if options[:d]
        params[:destination_port] = options[:e] if options[:e]
        params[:icmp_type_name]   = options[:i] if options[:i]
        params[:protocol]         = options[:p] if options[:p]
        params[:description]      = options[:description] if options[:description]
        params.nilify_blanks

        info "Updating firewall rule #{firewall_rule}"
        firewall_rule.update(params)

        render_table([firewall_rule], global_options)
      end
    end
  end
end
