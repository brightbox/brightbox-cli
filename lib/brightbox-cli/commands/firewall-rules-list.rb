module Brightbox
  desc 'List Firewall Rules'
  arg_name '[firewall-policy-id...]'
  command [:list] do |c|
    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the firewall_policy_id as the first argument"
      else
        firewall_policy_id = args.shift
        firewall_policy = FirewallPolicy.find_or_call(firewall_policy_id) do |id|
          raise "Couldn't find firewall policy #{id}"
        end
      end
      render_table(FirewallRules.from_policy(firewall_policy.first), global_options)
    end
  end
end
