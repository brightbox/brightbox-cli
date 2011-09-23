module Brightbox
  desc 'List Firewall Policies'
  arg_name '[firewall-policy-id...]'
  command [:list] do |c|
    c.action do |global_options,options,args|

      if args.empty?
        lbs = FirewallPolicy.find(:all)
      else
        lbs = FirewallPolicy.find_or_call(args) do |id|
          warn "Couldn't find firewall policy #{id}"
        end
      end

      render_table(lbs, global_options)
    end
  end
end
