desc 'Show detailed image info'
arg_name 'image-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    images = Image.find(args)

    rows = []

    images.each do |i|
      o = i.to_row
      rows << o
    end

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :type, :created_at, :status, :access, :arch, :name, :description ]
    })

    render_table(rows, table_opts)

  end
end
