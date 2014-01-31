module Brightbox
  class LoadBalancer < Api
    def self.require_account?; true; end
    def self.create(options)
      new(conn.load_balancers.create(options))
    end

    def attributes
      fog_model.attributes
    end

    def to_row
      attributes.merge(
        :ssl_issuer => certificate_issuer,
        :ssl_subject => certificate_subject,
        :ssl_valid_from => certificate_valid_from,
        :ssl_expires_at => certificate_expires_at,
        :nodes => node_ids,
        :created_on => created_on,
        :listeners => listeners,
        :cloud_ips => cloud_ip_ids
      )
    end

    def node_ids
      @node_ids ||= attributes[:nodes].map { |n| n["id"] } if attributes[:nodes]
    end

    def cloud_ip_ids
      @cloud_ip_ids ||= attributes["cloud_ips"].map { |n| n["id"] } if attributes["cloud_ips"]
    end

    def cloud_ips
      @cloud_ips ||= attributes["cloud_ips"].map { |n| n["public_ip"] } if attributes["cloud_ips"]
    end

    def listeners
      if attributes[:listeners]
        attributes[:listeners].map { |l| [l["in"], l["out"], l["protocol"], l['timeout']].join(":") }
      else
        nil
      end
    end

    def destroy
      fog_model.destroy
    rescue Excon::Errors::Conflict
      raise Conflict, "Cannot delete load balancer #{id}"
    end

    def add_nodes(nodes)
      node_hashes = nodes.map { |n| { :node => n.id } }
      LoadBalancer.conn.add_nodes_load_balancer(id, :nodes => node_hashes)
    end

    def remove_nodes(nodes)
      node_hashes = nodes.map { |n| { :node => n.id } }
      LoadBalancer.conn.remove_nodes_load_balancer(id, :nodes => node_hashes)
    end

    def update(options)
      LoadBalancer.conn.update_load_balancer(id, options)
      reload
      self
    end

    def self.get(id)
      conn.load_balancers.get id
    end

    def self.all
      conn.load_balancers
    end

    def self.default_field_order
      [:id, :status, :created_on, :cloud_ips, :nodes, :name]
    end
  end
end
