module Brightbox
  desc 'unmap Cloud IPs'
  arg_name 'cloudip-id...'
  command [:unmap] do |c|

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the Cloud IPs you want to unmap"
      end

      ips = CloudIP.find_or_call(args) do |id|
        raise "Couldn't find Cloud IP #{id}"
      end

      ips.each do |ip|
        if ip.mapped?
          info "Unmapping Cloud IP #{ip}"
          ip.unmap
          ip.reload
        else
          warn "Cloud IP #{ip} already unmapped"
        end
      end

      # Wait up to 3 seconds for unmapping to complete
      3.times do
        break unless ips.find { |ip| ip.mapped? }
        sleep 1
        ips.each { |ip| ip.reload if ip.mapped? }
      end

      render_table(ips, global_options)
    end
  end

end
