module Brightbox
  desc 'Destroy Firewall Rule'
  arg_name '[firewall-rule-id...]'
  command [:destroy] do |c|
    c.action do |global_options, options, args|

      raise "You must specify firewall-rule-id to destroy" if args.empty?
      firewall_rule_id = args.shift
      raise "Invalid FirewallRule id" unless firewall_rule_id[/^fwr-/]

      firewall_rule = FirewallRule.find(firewall_rule_id) do |id|
        raise "Couldn't find Firewall Rule #{id}"
      end

      info "Destroying firewall rule #{firewall_rule}"
      begin
        firewall_rule.destroy
      rescue Brightbox::Api::Conflict => e
        error "Could not destroy #{firewall_rule}"
      end

    end
  end
end
