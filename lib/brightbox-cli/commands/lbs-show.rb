module Brightbox
  command [:lbs] do |cmd|

    cmd.desc "Show detailed load balancer info"
    cmd.arg_name "lbs-id..."
    cmd.command [:show] do |c|

      c.action do |global_options, options, args|

        raise "You must specify load balancers to show" if args.empty?

        lbs = LoadBalancer.find_or_call(args) do |id|
          raise "Couldn't find lb #{id}"
        end

        table_opts = global_options.merge({
          :vertical => true,
          :fields => [:id, :status, :name, "created_at", "deleted_at", :policy, :cloud_ips, :nodes, :listeners, :healthcheck]
        })

        render_table(lbs, table_opts)

      end
    end
  end
end
