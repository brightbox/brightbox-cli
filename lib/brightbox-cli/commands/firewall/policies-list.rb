module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.default_command :list

    cmd.desc I18n.t("firewall.policies.list.desc")
    cmd.arg_name "[firewall-policy-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, _options, args|
        firewall_policies = FirewallPolicy.find_all_or_warn(args)
        render_table(firewall_policies, global_options)
      end
    end
  end
end
