module Brightbox
  desc 'Show detailed image info'
  arg_name 'image-id...'
  command [:show] do |c|

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the images you want to show"
      end

      images = Image.find_or_call(args) do |id|
        warn "Couldn't find image #{id}"
      end

      table_opts = global_options.merge({
                                          :vertical => true,
                                          :fields => [:id, :type, :owner, :created_at, :status, :arch, :name, :description, :virtual_size, :disk_size, :public, :"compatibility_mode", :official, :ancestor_id ]
                                        })

      render_table(images, table_opts)

    end
  end
end
