desc 'List zones'
arg_name '[zone-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

		# Get em
    if args.empty?
      zones = Api.conn.zones
    else
      zones = args.collect { |arg| Api.conn.zones.get arg }
    end

    render_table(zones, :fields => [:id, :name],
                 :global => global_options)
  end
end
