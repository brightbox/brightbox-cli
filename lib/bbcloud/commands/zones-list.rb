desc 'List zones'
arg_name '[zone-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

    zones = Zone.find args
    render_table(zones, global_options)
  end
end
