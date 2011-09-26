module Brightbox
  desc 'Show Firewall Rule'
  arg_name 'firewall-rule-id'
  command [:show] do |c|
    c.action do |global_options, options, args|
      raise "You must specify server groups to show" if args.empty?

      policies = FirewallRule.find_or_call(args) do |id|
        raise "Couldn't find Firewall Rule #{id}"
      end

      table_opts = global_options.update(:vertical => true)
      render_table(policies, table_opts)
    end
  end
end

