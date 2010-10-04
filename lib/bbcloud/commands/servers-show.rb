desc 'Show detailed server info'
arg_name 'server-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    servers = args.collect { |arg| Api.conn.servers.get(arg) || arg }
    
    servers.each do |s|
      if s.is_a? String
        error "Could not find server #{s}"
        next
      end
      field "id", s.id
      field "name", s.name
      field "description", s.description
      field "status", s.status
      if type = Api.conn.flavors.get(s.flavor_id)
        field "type", "#{type.id} (#{type.name})"
        field "ram", type.ram
        field "cores", type.cores
        field "disk", type.disk.to_i
      else
        field "type", s.flavor_id
      end
      if image = Api.conn.images.get(s.image_id)
        field "image", "#{image.id} (#{image.name})"
        field "arch", image.arch
      else
        field "image", s.image_id
      end
      field "created_at", s.created_at
      field "deleted_at", s.deleted_at
      field "private ips", s.interfaces.collect { |i| i['ipv4_address'] }.join(", ")
      info ""
    end

  end
end
