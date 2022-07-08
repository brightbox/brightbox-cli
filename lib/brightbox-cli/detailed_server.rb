module Brightbox
  class DetailedServer < Server
    def to_row
      row_attributes = attributes

      row_attributes[:compatibility_mode] = row_attributes["compatibility_mode"]

      if server_type
        row_attributes[:type] = server_type["id"]
        row_attributes[:type_handle] = server_type["handle"]
        row_attributes[:type_name] = server_type["name"]
        row_attributes[:ram] = server_type["ram"]
        row_attributes[:cores] = server_type["cores"]
        row_attributes[:disk] = server_type["disk_size"].to_i
      end

      if image
        row_attributes[:image_name] = image.name
        row_attributes[:arch] = image.arch
      end

      row_attributes[:private_ips] = interfaces.map { |i| i["ipv4_address"] }.join(", ")
      row_attributes[:ipv6_address] = interfaces.map { |i| i["ipv6_address"] }.join(", ")

      row_attributes[:cloud_ip_ids] = cloud_ips.map { |i| i["id"] }.join(", ")
      row_attributes[:cloud_ipv4s] = cloud_ips.map { |i| i["public_ipv4"] }.join(", ")
      row_attributes[:cloud_ipv6s] = cloud_ips.map { |i| i["public_ipv6"] }.join(", ")
      row_attributes[:snapshots] = snapshots.map { |i| i["id"] }.join(", ")

      if server_groups
        row_attributes[:server_groups] = server_groups.map { |sg| sg["id"] }.join(", ")
      end

      row_attributes
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
      ]
    end
  end
end
