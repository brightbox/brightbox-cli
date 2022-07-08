module Brightbox
  command [:lbs] do |cmd|
    cmd.desc I18n.t("lbs.destroy.desc")
    cmd.arg_name "lb-id..."
    cmd.command [:destroy] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify the load balancers to destroy" if args.empty?

        lbs = LoadBalancer.find_or_call(args) do |id|
          raise "Couldn't find load balancer #{id}"
        end

        lbs.each do |lb|
          info "Destroying load balancer #{lb}"
          lb.destroy
        end
      end
    end
  end
end
