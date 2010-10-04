desc 'Create servers'
arg_name 'image_id [server-id...]'
command [:create] do |c|
  c.desc "Number of servers to create"
  c.default_value 1
  c.flag [:i, "server-count"]

  c.desc "Set description field"
  c.flag [:d, :description]

  c.desc "Set the type"
  c.default_value "typ-4nssg"
  c.flag [:t, :type]

  c.action do |global_options, options, args|

    if args.empty?
      raise "You must specify the image_id as the first argument"
    end

    image_id = args.shift
    image = Api.conn.images.get image_id
    raise "Couldn't find image #{image_id}" unless image
    
    type_id = options[:t]
    type = Api.conn.flavors.get type_id
    raise "Couldn't find server type #{type_id}" unless type

    info "Creating #{options[:i]} '#{type.name}' server#{options[:i] > 1 ? 's' : ''} with image #{image.id} (#{image.name})"
    servers = []
    options[:i].to_i.times do
      begin
        servers << Api.conn.servers.create(:image_id => image.id, 
                                      :description => options[:d])
      rescue StandardError => e
        error "Error creating server"
      end
    end
    render_table(servers, :fields => [:id, :status, :type, :image, :created_at, 
                                      :ips, :description],
                 :global => global_options)
  end
end
