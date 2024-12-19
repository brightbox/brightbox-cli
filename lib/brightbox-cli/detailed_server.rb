module Brightbox
  class DetailedServer < Server
    def to_row
      attributes.tap do |attrs|
        attrs[:compatibility_mode] = attrs["compatibility_mode"]

        if server_type
          attrs[:type] = server_type["id"]
          attrs[:type_handle] = server_type["handle"]
          attrs[:type_name] = server_type["name"]
          attrs[:ram] = server_type["ram"]
          attrs[:cores] = server_type["cores"]
          attrs[:disk] = server_type["disk_size"].to_i
        end

        if image
          attrs[:image_name] = image.name
          attrs[:arch] = image.arch
          attrs[:image_username] = image.username
        end

        attrs[:private_ips] = interfaces.map { |i| i["ipv4_address"] }.join(", ")
        attrs[:ipv6_address] = interfaces.map { |i| i["ipv6_address"] }.join(", ")

        attrs[:cloud_ip_ids] = cloud_ips.map { |i| i["id"] }.join(", ")
        attrs[:cloud_ipv4s] = cloud_ips.map { |i| i["public_ipv4"] }.join(", ")
        attrs[:cloud_ipv6s] = cloud_ips.map { |i| i["public_ipv6"] }.join(", ")
        attrs[:snapshots] = snapshots.map { |i| i["id"] }.join(", ")

        if server_groups
          attrs[:server_groups] = server_groups.map { |sg| sg["id"] }.join(", ")
        end

        attrs[:volumes] = volume_ids if volumes
      end.to_h
    end

    def volume_ids
      volumes.map do |vol|
        if vol["boot"] == true
          "*#{vol['id']}*"
        else
          vol["id"]
        end
      end.join(", ")
    end

    def self.default_field_order
      %i[
        id
        status
        locked
        name
        created_at
        deleted_at
        zone
        type
        type_name
        type_handle
        ram
        cores
        disk
        disk_encrypted
        compatibility_mode
        image
        image_name
        image_username
        arch
        private_ips
        ipv6_address
        hostname
        fqdn
        public_hostname
        ipv6_hostname
        cloud_ip_ids
        cloud_ipv4s
        cloud_ipv6s
        snapshots
        server_groups
        volumes
      ]
    end
  end
end
