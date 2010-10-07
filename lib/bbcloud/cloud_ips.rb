module Brightbox
  class CloudIP < Api
    def self.get id
      conn.cloud_ips.get id
    end

    def self.all
      conn.cloud_ips
    end

    def self.create
      r = conn.create_cloud_ip
      new(JSON.parse(r.body)["id"])
    end

    def attributes
      fog_model.attributes
    end

    def to_row
      attributes
    end

    def self.default_field_order
      [:id, :status, :public_ip, :server_id, :interface_id, :reverse_dns]
    end

  end
end
