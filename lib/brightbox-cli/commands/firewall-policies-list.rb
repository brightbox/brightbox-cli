module Brightbox
  desc 'List Firewall Policies'
  arg_name '[firewall-policy-id...]'
  command [:list] do |c|
    c.action do |global_options,options,args|

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
