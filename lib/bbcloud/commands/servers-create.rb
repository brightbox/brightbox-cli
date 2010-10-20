desc 'Create servers'
arg_name 'image_id'
command [:create] do |c|
  c.desc "Number of servers to create"
  c.default_value 1
  c.flag [:i, "server-count"]

  c.desc "Zone to create the servers in"
  c.flag [:z, "zone"]

  c.desc "Type of server to create"
  c.default_value "nano"
  c.flag [:t, :type]

  c.desc "Friendly name of server"
  c.flag [:n, :name]


  c.action do |global_options, options, args|

    if args.empty?
      raise "You must specify the image_id as the first argument"
    end

    if options[:i].to_s !~ /^[0-9]+$/
      raise "server-count must be a number"
    end

    options[:i] = options[:i].to_i

    image_id = args.shift
    image = Image.find image_id
    raise "Couldn't find image #{image_id}" unless image
    
    type_id = options[:t]
    if type_id =~ /^typ\-/
      type = Type.find type_id
    else
      type = Type.find_by_handle type_id
    end
    raise "Couldn't find server type #{type_id}" unless type

    if options[:z]
      zone = options[:z]
      if zone =~ /^typ\-/
        zone = Zone.find zone
      else
        zone = Zone.find_by_handle zone
      end
    end
    raise "Couldn't find server type #{type_id}" unless type

    msg = "Creating #{options[:i]} #{type.id} (#{type.handle}) server#{options[:i] > 1 ? 's' : ''} with image #{image.id} (#{image.name})"
    msg << "in zone #{zone}" if zone
    info msg
    servers = []
    options[:i].times do
      servers << Server.create(:image_id => image.id,
                               :flavor_id => type.id,
                               :zone_id => zone.to_s,
                               :name => options[:n])
    end
    render_table(servers, global_options)
  end
end
