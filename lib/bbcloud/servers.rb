module Fog
  module Brightbox
    class Compute
      class Server
        def to_row(options = {})
          flavors = options[:flavors] || {}
          o = { }
          o[:id] = id 
					o[:status] = status
          o[:image] = image_id
          o[:description] = description.to_s.strip
          o[:created_at] = created_at
          o[:type] = flavor_id
					o[:ips] = interfaces.collect { |i| i['ipv4_address'] }.join(', ')
          o[:zone] = zone_id
          o[:cloud_ips] = cloud_ips.collect { |i| i['public_ip'] }
          o
        end
      end
    end
  end
end
