module Brightbox
  desc 'Destroy Firewall Rule'
  arg_name '[firewall-rule-id...]'
  command [:destroy] do |c|
    c.action do |global_options, options, args|

      raise "You must specify firewall-rule-id to destroy" if args.empty?

      firewall_rules = FirewallRule.find_or_call(args) do |id|
        raise "Couldn't find Firewall Rule #{id}"
      end

      firewall_rules.each do |firewall_rule|
        info "Destroying firewall rule #{firewall_rule}"
        begin
          firewall_rule.destroy
        rescue Brightbox::Api::Conflict => e
          error "Could not destroy #{firewall_rule}"
        end
      end

    end
  end
end
