module Brightbox
  class LoadBalancer < Api

    def self.create(options)
      new(conn.load_balancers.create(options))
    end

    def attributes
      fog_model.attributes
    end

    def to_row
      attributes.merge :nodes => node_ids,
      :created_on => created_on,
      :listeners => listeners
    end

    def created_on
      attributes["created_at"].to_s.split('T').first
    end

    def node_ids
      @node_ids ||= attributes[:nodes].collect { |n| n["id"] }
    end

    def listeners
      if attributes[:listeners]
        attributes[:listeners].collect { |l| [l["in"], l["out"], l["protocol"]].join(":") }
      else
        nil
      end
    end

    def destroy
      fog_model.destroy
    rescue Excon::Errors::Conflict => e
      raise Conflict, "Cannot delete load balancer #{id}"
    end

    def add_nodes(nodes)
      node_hashes = nodes.collect { |n| { :node => n.id } }
      LoadBalancer.conn.add_nodes_load_balancer(id, :nodes => node_hashes)
    rescue Excon::Errors::BadRequest => e
      raise Conflict, JSON.parse(e.response.body)['error']['details']
    end

    def remove_nodes(nodes)
      node_hashes = nodes.collect { |n| { :node => n.id } }
      LoadBalancer.conn.remove_nodes_load_balancer(id, :nodes => node_hashes)
    rescue Excon::Errors::BadRequest => e
      raise Conflict, JSON.parse(e.response.body)['error']['details']
    end

    def self.get(id)
      conn.load_balancers.get id
    end

    def self.all
      conn.load_balancers
    end

    def self.default_field_order
      [:id, :status, :created_on, :nodes, :name]
    end

  end
end
