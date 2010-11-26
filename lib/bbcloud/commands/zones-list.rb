desc 'List zones'
arg_name '[zone-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

    if args.empty?
      zones = Zone.find(:all)
    else
      zones = Zone.find_or_call(args) do |id|
        warn "Couldn't find zone #{id}"
      end
    end

    render_table(zones, global_options)
  end
end
