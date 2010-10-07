desc 'Show detailed type info'
arg_name 'type-id...'
command [:show] do |c|

  c.action do |global_options,options,args|
    
    types = Type.find(args)
    rows = []
    types.each do |t|
      next if t.nil?
      rows << t
    end

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :handle, :status, :name, :ram, :disk, :cores, :description]
    })

    render_table(rows, table_opts)

  end
end
