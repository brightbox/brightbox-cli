module Brightbox
  command [:cloudips] do |cmd|

    cmd.desc "map Cloud IPs"
    cmd.arg_name "cloudip-id destination"
    cmd.command [:map] do |c|

      c.desc "Unmap mapped IPs before remapping them"
      c.switch [:u, "unmap"], :negatable => false

      c.action do |global_options, options, args|

        if args.size > 2
          raise "Too many arguments"
        end

        if args.size < 2
          raise "You must specify the cloud ip id and the destination"
        end

        ip_id = args.first

        ip = CloudIP.find ip_id

        destination_id = args.last
        case destination_id
        when /^srv\-/
          server = Server.find destination_id
          destination_id = server.interfaces.first["id"]
          info "Mapping #{ip} to interface #{destination_id} on #{server}"
        else
          info "Mapping #{ip} to destination #{destination_id}"
        end

        if ip.mapped?
          if options[:u]
            ip.unmap
            3.times do
              break unless ip.mapped?
              sleep 1
              ip.reload
            end
          else
            raise "Refusing to map already mapped IP #{ip}"
          end
        end

        ip.map destination_id

        # Wait up to 3 seconds for mapping to complete
        3.times do
          ip.reload
          break if ip.mapped?
          sleep 1
        end

        render_table([ip], global_options)
      end
    end
  end
end
