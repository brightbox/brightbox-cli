module Brightbox
  command [:lbs] do |cmd|

    cmd.desc "Show detailed load balancer info"
    cmd.arg_name "lbs-id..."
    cmd.command [:show] do |c|

      c.action do |global_options, options, args|
        lbs = LoadBalancer.find_all_or_warn(args)

        table_opts = global_options.merge(
          :vertical => true,
          :fields => [
            :id,
            :status,
            :name,
            :created_at,
            :deleted_at,
            :policy,
            :ssl_issuer,
            :ssl_subject,
            :ssl_valid_from,
            :ssl_expires_at,
            :cloud_ips,
            :nodes,
            :listeners,
            :healthcheck
        ])

        render_table(lbs, table_opts)

      end
    end
  end
end
