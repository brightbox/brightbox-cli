desc 'unmap Cloud IPs'
arg_name 'cloudip-id...'
command [:unmap] do |c|

  c.action do |global_options,options,args|

    ips = CloudIP.find args
    ips.each do |ip|
      if ip.mapped?
        ip.unmap
        ip.reload
      else
        warn "#{ip} already unmapped"
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
