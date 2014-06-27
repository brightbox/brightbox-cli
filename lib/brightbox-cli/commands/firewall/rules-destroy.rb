module Brightbox
  command [:"firewall-rules"] do |cmd|

    cmd.desc I18n.t("firewall.rules.destroy.desc")
    cmd.arg_name "[firewall-rule-id...]"
    cmd.command [:destroy] do |c|

      c.action do |_global_options, _options, args|
        raise "You must specify firewall-rule-id to destroy" if args.empty?

        firewall_rules = FirewallRule.find_or_call(args) do |id|
          raise "Couldn't find Firewall Rule #{id}"
        end

        firewall_rules.each do |firewall_rule|
          info "Destroying firewall rule #{firewall_rule}"
          begin
            firewall_rule.destroy
          rescue Brightbox::Api::Conflict
            error "Could not destroy #{firewall_rule}"
          end
        end
      end
    end
  end
end
