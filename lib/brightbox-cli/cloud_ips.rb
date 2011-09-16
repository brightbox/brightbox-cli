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
      new(r["id"])
    rescue Excon::Errors::Forbidden => e
      response = JSON.parse(e.response.body) rescue {}
      response = response.fetch("error", {})
      raise Forbidden, "#{response["details"]}: #{response["summary"]}"
    end

    def attributes
      a = fog_model.attributes
      if a["load_balancer"]
        a[:destination] = a["load_balancer"]["id"]
      else
        a[:destination] = a[:server_id]
      end
      a
    end

    def to_row
      attributes
    end

    def mapped?
      status == 'mapped'
    end

    def self.default_field_order
      [:id, :status, :public_ip, :destination, :reverse_dns]
    end

    def <=>(b)
      self.status <=> b.status
    end
  end
end
