desc 'map Cloud IPs'
arg_name 'cloudip-id server-id'
command [:map] do |c|
  c.desc "Unmap mapped ips before remapping them"
  c.switch [:u, "unmap"]

  c.action do |global_options,options,args|

    if args.size > 2
      raise "Too many arguments"
    end

    if args.size < 2
      raise "You must specify the cloud ip id and the server id"
    end

    ip_id = args.first

    ip = CloudIP.find ip_id

    raise "Cannot find ip #{ip_id}" if ip.nil?

    if ip.mapped?
      if options[:u]
        info "Unmapping ip #{ip}"
        ip.unmap
        3.times do
          break unless ip.mapped?
          sleep 1
          ip.reload
        end
      else
        raise "Refusing to map already mapped ip #{ip}"
      end
    end

    server_id = args.last
    server = Server.find server_id
    raise "Cannot find server #{server_id}" if server.nil?
    
    interface_id = server.interfaces.first["id"]
    info "Mapping #{ip} to interface #{interface_id} on #{server}"

    ip.map interface_id

    # Wait up to 3 seconds for mapping to complete
    3.times do
      sleep 1
      ip.reload
      break if ip.mapped?
    end

    render_table([ip], global_options)
  end
end
