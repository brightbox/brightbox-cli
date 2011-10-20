module Brightbox
  desc 'Show Firewall Rule'
  arg_name 'firewall-rule-id'
  command [:show] do |c|
    c.action do |global_options, options, args|
      raise "You must specify server groups to show" if args.empty?

      policies = FirewallRule.find_or_call(args) do |id|
        raise "Couldn't find Firewall Rule #{id}"
      end

      display_options = { :fields => [
          :id, :protocol,:source, :sport,:destination, :dport, :icmp_type, :firewall_policy
        ],
        :vertical => true
      }
      table_opts = global_options.update(display_options)
      render_table(policies, table_opts)
    end
  end
end

