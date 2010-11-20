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
      a[:created_at] = created_at
      a[:created_on] = fog_model.created_at.strftime("%Y-%m-%d")
      a[:type] = server_type
      a[:zone] = Zone.new(zone_id)
      a[:hostname] = hostname
      a[:public_hostname] = public_hostname unless cloud_ips.empty?
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

    def destroy
      fog_model.destroy
    rescue Excon::Errors::Conflict => e
      raise Conflict, "Cannot delete server #{id}"
    end

    def self.get(id)
      conn.servers.get id
    end

    def self.all
      conn.servers
    end

    def self.default_field_order
      [:id, :status, :type, :zone, :created_on, :image_id, :cloud_ips, :name]
    end

    def hostname
      "#{id}.gb1.brightbox.com"
    end

    def public_hostname
      "public.#{hostname}"
    end
  end
end
