module Brightbox
  command [:lbs] do |cmd|

    cmd.desc "List load balancers"
    cmd.arg_name "[lb-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, options, args|

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
end
