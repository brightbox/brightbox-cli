desc 'Show detailed server info'
arg_name 'server-id...'
command [:show] do |c|

  c.action do |global_options,options,args|
    servers = args.collect { |arg| Api.conn.servers.get(arg) || arg }
    rows = []
    servers.each do |s|
      if s.is_a? String
        error "Could not find server #{s}"
        next
      end
      o = s.attributes
      o[:zone] = s.zone_id
      if zone = Api.conn.zones.get(s.zone_id)
        o[:zone] = zone.name
      end
      o[:type] = s.flavor_id
      if type = Api.conn.flavors.get(s.flavor_id)
        o[:type_name] = type.name
        o[:ram] = type.ram
        o[:cores] = type.cores
        o[:disk] = type.disk.to_i
      end
      o[:image] = s.image_id
      if image = Api.conn.images.get(s.image_id)
        o[:image_name] = image.name
        o[:arch] = image.arch
      end
      o[:private_ips] = s.interfaces.collect { |i| i['ipv4_address'] }.join(", ")
      o[:cloud_ip_ids] = s.cloud_ips.collect { |i| i['id'] }.join(", ")
      o[:cloud_ips] = s.cloud_ips.collect { |i| i['public_ip'] }.join(", ")
      rows << o
    end

    render_table(rows, { 
                  :vertical => true, 
                  :fields => [:id, :status, :name, :description, :created_at, :deleted_at, 
                              :zone, :type, :type_name, :ram, :cores, 
                              :disk, :image, :image_name, :private_ips, :cloud_ips, 
                              :cloud_ip_ids
                             ],
                  :global => global_options})

  end
end
