module Brightbox
  class Server < Api
    def self.require_account?; true; end

    def self.create_servers(count, options)
      (0...count).map { |_i| create(options) }
    end

    def self.create(options)
      new(conn.servers.create(options))
    end

    def self.all
      conn.servers
    end

    def self.get(id)
      conn.servers.get id
    end

    def self.default_field_order
      %i[id status type zone created_on image_id cloud_ip_ids name]
    end

    def update(options)
      self.class.conn.update_server id, options
      reload
      self
    end

    def destroy
      fog_model.destroy
    end

    def activate_console
      self.class.conn.activate_console_server id
    end

    def attributes
      fog_attributes.tap do |attrs|
        attrs[:created_at] = created_at
        attrs[:created_on] = created_on
        attrs[:hostname] = hostname
        attrs[:image] = image_id
        attrs[:locked] = locked?
        attrs[:status] = fog_model.state
        attrs[:type] = server_type["handle"]
        attrs[:zone] = zone && zone["handle"]

        unless cloud_ips.empty?
          attrs[:public_hostname] = "public.#{fqdn}"
        end

        if interfaces.any? { |i| i["ipv6_address"] }
          attrs[:ipv6_hostname] = ipv6_fqdn
        end
      end
    end

    def to_row
      attributes.merge(
        cloud_ips: cloud_ips.map { |i| i["public_ip"] }.join(", "),
        ips: interfaces.map { |i| i["ipv4_address"] }.join(", ")
      )
    end

    def deleted?
      fog_model.status == "deleted"
    end

    def ipv6_fqdn
      "ipv6.#{fqdn}"
    end
  end
end
