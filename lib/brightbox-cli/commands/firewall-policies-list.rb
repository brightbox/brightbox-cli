module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.default_command :list

    cmd.desc "List Firewall Policies"
    cmd.arg_name "[firewall-policy-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, options, args|

        if args.empty?
          firewall_policies = FirewallPolicy.find(:all)
        else
          firewall_policies = FirewallPolicy.find_or_call(args) do |id|
            warn "Couldn't find firewall policy #{id}"
          end
        end
        render_table(firewall_policies, global_options)
      end
    end
  end
end
