desc 'Show detailed image info'
arg_name 'image-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    images = Image.find(args).compact

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :type, :owner, :created_at, :status, :arch, :name, :description, :virtual_size, :disk_size, :ancestor_id ]
    })

    render_table(images, table_opts)

  end
end
