module Brightbox
  desc 'List load balancers'
  arg_name '[lb-id...]'
  command [:list] do |c|
    c.action do |global_options,options,args|

      if args.empty?
        lbs = LoadBalancer.find(:all)
      else
        lbs = LoadBalancer.find_or_call(args) do |id|
          warn "Couldn't find load balancer #{id}"
        end
      end

      render_table(lbs, global_options)
    end
  end
end
