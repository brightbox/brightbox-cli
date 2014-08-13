module Brightbox
  command [:lbs] do |cmd|
    cmd.desc I18n.t("lbs.lock.desc")
    cmd.arg_name "[lbs-id...]"
    cmd.command [:lock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify load balancers as arguments" if args.empty?

        balancers = LoadBalancer.find_or_call(args) do |balancer|
          raise "Couldn't find #{balancer}"
        end

        balancers.each do |balancer|
          info "Locking #{balancer}"
          balancer.lock!
        end
      end
    end

    cmd.desc I18n.t("lbs.unlock.desc")
    cmd.arg_name "[lbs-id...]"
    cmd.command [:unlock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify load balancers as arguments" if args.empty?

        balancers = LoadBalancer.find_or_call(args) do |balancer|
          raise "Couldn't find #{balancer}"
        end

        balancers.each do |balancer|
          info "Unlocking #{balancer}"
          balancer.unlock!
        end
      end
    end
  end
end
