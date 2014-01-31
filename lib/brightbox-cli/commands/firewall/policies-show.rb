module Brightbox
  command [:"firewall-policies"] do |cmd|

    cmd.desc "Show Firewall Policy"
    cmd.arg_name "firewall-policy-id"
    cmd.command [:show] do |c|

      c.action do |global_options, options, args|
        raise "You must specify server groups to show" if args.empty?

        policies = FirewallPolicy.find_or_call(args) do |id|
          raise "Couldn't find Firewall Policy #{id}"
        end

        table_opts = global_options.update(
          :vertical => true,
          :fields => [
            :id,
            :server_group,
            :default,
            :name,
            :description
          ]
        )

        render_table(policies, table_opts)
      end
    end
  end
end
