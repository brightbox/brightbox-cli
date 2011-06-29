module Brightbox
  desc 'destroy Cloud IPs'
  arg_name '[cloudip-id...]'
  command [:destroy] do |c|
    c.desc "Unmap mapped ips before destroying them"
    c.switch [:u, "unmap"]

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the cloud ips you want to destroy"
      end

      ips = CloudIP.find_or_call(args) do |id|
        raise "Couldn't find cloud ip #{id}"
      end

      ips.each do |ip|

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
        info "Destroying cloud ip #{ip}"
        ip.destroy
      end

    end
  end
  
end
