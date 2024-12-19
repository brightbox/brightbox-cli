module Brightbox
  class LoadBalancer < Api
    def self.require_account?; true; end

    def self.create(options)
      options.delete(:buffer_size) if options[:buffer_size].nil?
      options[:buffer_size] = options[:buffer_size].to_i if options[:buffer_size]

      new(conn.load_balancers.create(options))
    end

    def formatted_acme_domains
      return "" unless attributes[:acme]

      attributes[:acme][:domains].map do |domain|
        [domain[:identifier], domain[:status]].join(":")
      end.join(",")
    rescue StandardError
      ""
    end

    def to_row
      attributes.merge(
        :locked => locked?,
        :acme_domains => formatted_acme_domains,
        :ssl_minimum_version => ssl_minimum_version,
        :ssl_issuer => certificate_issuer,
        :ssl_subject => certificate_subject,
        :ssl_valid_from => certificate_valid_from,
        :ssl_expires_at => certificate_expires_at,
        :ssl_v3_enabled => certificate_enable_ssl3,
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
      cips = attributes["cloud_ips"] || attributes[:cloud_ips]
      @cloud_ip_ids ||= cips.map { |n| n["id"] } if cips
    end

    def cloud_ips
      cips = attributes["cloud_ips"] || attributes[:cloud_ips]
      @cloud_ips ||= cips.map { |n| n["public_ip"] } if cips
    end

    def listeners
      attributes[:listeners]&.map { |l| [l["in"], l["out"], l["protocol"], l["timeout"]].join(":") }
    end

    def buffer_size
      attributes[:buffer_size]
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
      %i[id status created_on cloud_ips nodes name]
    end
  end
end
