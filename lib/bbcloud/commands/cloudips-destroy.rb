desc 'destroy Cloud IPs'
arg_name '[cloudip-id...]'
command [:destroy] do |c|
  c.desc "Unmap mapped ips before destroying them"
  c.switch [:u, "unmap"]

  c.action do |global_options,options,args|

    if args.size < 1
      raise "You must specify the cloud ip id you want to destroy"
    end

    args.each do |ip_id|

      ip = CloudIP.find ip_id

      raise "Cannot find cloud ip #{ip_id}" if ip.nil?

      if ip.mapped?
        if options[:u]
          info "Unmapping cloud ip #{ip}"
          ip.unmap
          3.times do
            break unless ip.mapped?
            sleep 1
            ip.reload
          end
        else
          raise "Cannot destroy mapped cloud ip #{ip}"
        end
      end
      info "Destroying cloud ip #{ip.public_ip} (#{ip})"
      ip.destroy
    end

  end
end
