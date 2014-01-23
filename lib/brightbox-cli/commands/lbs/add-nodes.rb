module Brightbox
  desc "Manages an account's load balancers"
  command [:lbs] do |cmd|

    cmd.desc "Add nodes to a load balancer"
    cmd.arg_name "lb-id node-id..."
    cmd.command [:add_nodes] do |c|

      c.action do |global_options, options, args|

        raise "You must specify the load balancer and the node ids to add" if args.size < 2

        lb = LoadBalancer.find(args.shift)

        nodes = Server.find_or_call(args) do |id|
          raise "Couldn't find server #{id}"
        end

        info "Adding #{nodes.size} nodes to load balancer #{lb.id}"
        lb.add_nodes nodes
        lb.reload
        render_table([lb], global_options)
      end
    end
  end
end
