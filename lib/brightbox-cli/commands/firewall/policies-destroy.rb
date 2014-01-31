module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.desc "Destroy Firewall Policy"
    cmd.arg_name "[firewall-policy-id...]"
    cmd.command [:destroy] do |c|

      c.action do |global_options, options, args|

        raise "You must specify firewall-policy-id to destroy" if args.empty?

        firewall_policies = FirewallPolicy.find_or_call(args) do |id|
          raise "Couldn't find Firewall Policy #{id}"
        end

        firewall_policies.each do |firewall_policy|
          info "Destroying firewall policy #{firewall_policy}"
          begin
            firewall_policy.destroy
          rescue Brightbox::Api::Conflict
            error "Could not destroy #{firewall_policy}"
          end
        end
      end
    end
  end
end
