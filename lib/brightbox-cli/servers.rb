module Brightbox
  class Server < Api

    def self.create_servers(count,options)
      (0...count).map {|i| create(options) }
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
      [:id, :status, :type, :zone, :created_on, :image_id, :cloud_ip_ids, :name]
    end

    def update options
      self.class.conn.update_server id, options
      self.reload
      self
    end

    def destroy
      fog_model.destroy
    end

    def activate_console
      self.class.conn.activate_console_server id
    end

    def attributes
      a = fog_model.attributes
      a[:image] = image_id
      a[:created_at] = created_at
      a[:created_on] = fog_model.created_at.strftime("%Y-%m-%d")
      a[:type] = server_type['handle']
      a[:status] = fog_model.state
      a[:zone] = zone && zone['handle']
      a[:hostname] = id
      a[:public_hostname] = fqdn unless cloud_ips.empty?
      a[:ipv6_hostname] = ipv6_fqdn if interfaces.any? {|i| i['ipv6_address'] }
      a
    end

    def to_row
      o = attributes
      o[:cloud_ip_ids] = cloud_ips.collect { |i| i['id'] }
      o[:ips] = interfaces.collect { |i| i['ipv4_address'] }.join(', ')
      o
    end

    def deleted?
      fog_model.status == "deleted"
    end

    def ipv6_fqdn
      "ipv6.#{fqdn}"
    end
  end

end
