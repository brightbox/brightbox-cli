module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.default_command :list

    cmd.desc "List Firewall Policies"
    cmd.arg_name "[firewall-policy-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, options, args|
        firewall_policies = FirewallPolicy.find_all_or_warn(args)
        render_table(firewall_policies, global_options)
      end
    end
  end
end