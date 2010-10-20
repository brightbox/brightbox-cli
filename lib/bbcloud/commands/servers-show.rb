desc 'Show detailed server info'
arg_name 'server-id...'
command [:show] do |c|

  c.action do |global_options,options,args|
    
    servers = Server.find(args)
    rows = []
    servers.each do |s|
      if s.is_a? String
        error "Could not find server #{s}"
        next
      end
      o = s.to_row
      if s.server_type.exists?
        o[:type] = s.server_type.id
        o[:type_handle] = s.server_type.handle
        o[:type_name] = s.server_type.name
        o[:ram] = s.server_type.ram
        o[:cores] = s.server_type.cores
        o[:disk] = s.server_type.disk.to_i
      end

      if s.image.exists? and false
        o[:image_name] = s.image.name
        o[:arch] = s.image.arch
      end
      o[:private_ips] = s.interfaces.collect { |i| i['ipv4_address'] }.join(", ")
      o[:cloud_ip_ids] = s.cloud_ips.collect { |i| i['id'] }.join(", ")
      o[:cloud_ips] = s.cloud_ips.collect { |i| i['public_ip'] }.join(", ")
      o[:snapshots] = s.snapshots.collect { |i| i['id'] }.join(", ")
      rows << o
    end

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :status, :name, :description, :created_at, :deleted_at, 
                  :zone, :type, :type_name, :type_handle, :ram, :cores, 
                  :disk, :image, :image_name, :private_ips, :cloud_ips, 
                  :cloud_ip_ids, :hostname, :public_hostname, :snapshots
                 ]
    })

    render_table(rows, table_opts)

  end
end
