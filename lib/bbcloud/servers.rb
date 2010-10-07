module Brightbox
  class Server < Api

    def self.create(options)
      new(conn.servers.create(options))
    end

    def server_type
      @server_type ||= Type.new(flavor_id)
    end

    def image
      @image ||= Image.new(image_id)
    end

    def attributes
      a = fog_model.attributes
      a[:image] = image
      a[:description] = description.to_s.strip
      a[:created_at] = created_at
      a[:type] = server_type
      a[:zone] = Zone.new(zone_id)
      a
    end

    def to_row
      o = attributes
      o[:cloud_ips] = cloud_ips.collect { |i| i['public_ip'] }
      o[:ips] = interfaces.collect { |i| i['ipv4_address'] }.join(', ')
      o
    end

    def deleted?
      fog_model.status == "deleted"
    end

    def self.get(id)
      conn.servers.get id
    end

    def self.all
      conn.servers
    end

    def self.default_field_order
      [:id, :status, :type, :zone, :created_at, :image_id, :cloud_ips, :description]
    end
  end
end
