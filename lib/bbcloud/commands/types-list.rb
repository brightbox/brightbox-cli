desc 'List types'
arg_name '[type-id...]'
command [:list] do |c|
  c.action do |global_options,options,args|

		# Get em
    if args.empty?
      types = Api.conn.flavors
    else
      types = args.collect { |arg| Api.conn.flavors.get arg }
    end

    # Sort
    types.sort! { |a,b| a.ram <=> b.ram }

    # Filter
    types.delete_if do |s|
      next true if !options[:d] and s.status == "deleted"
      false
    end

    render_table(types, :fields => [:id, :name, :status, :ram, :disk,
                                    :cores, :description],
                 :global => global_options)
  end
end
