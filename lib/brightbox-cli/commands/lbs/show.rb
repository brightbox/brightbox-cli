module Brightbox
  command [:lbs] do |cmd|
    cmd.desc I18n.t("lbs.show.desc")
    cmd.arg_name "lbs-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        raise "You must specify load balancer IDs to show" if args.empty?

        lbs = LoadBalancer.find_or_call(args) do |id|
          raise "Couldn't find a load balancer with ID #{id}"
        end

        table_opts = global_options.merge(
          :vertical => true,
          :fields => %i[
            id
            status
            locked
            name
            created_at
            deleted_at
            policy
            acme_domains
            acme_cert_subjects
            acme_cert_fingerprint
            acme_cert_expires_at
            acme_cert_issued_at
            ssl_minimum_version
            ssl_issuer
            ssl_subject
            ssl_valid_from
            ssl_expires_at
            ssl_v3_enabled
            cloud_ips
            nodes
            listeners
            healthcheck
          ]
        )

        render_table(lbs, table_opts)
      end
    end
  end
end
