module Brightbox
  class ServerGroup < Api
    def self.require_account?; true; end

    def self.all
      conn.server_groups
    end

    def self.get(id)
      conn.server_groups.get(id)
    end

    def self.create(options)
      new(conn.server_groups.create(options))
    end

    def self.default_field_order
      %i[id server_count name]
    end

    def firewall_policy
      FirewallPolicy.all.find do |policy|
        policy.server_group_id == id
      end
    end

    def update(options)
      self.class.conn.update_server_group(id, options)
      reload
      self
    end

    def destroy
      fog_model.destroy
    end

    def to_row
      super.merge(
        servers: server_string,
        server_count: server_count
      ).to_h
    end

    def server_ids
      attributes[:server_ids].map { |id| id.is_a?(Hash) ? id["id"] : id }
    end

    def server_count
      server_ids.respond_to?(:size) ? server_ids.size : 0
    end

    def server_string
      server_ids.respond_to?(:join) ? server_ids.join(" ") : ""
    end
  end
end
