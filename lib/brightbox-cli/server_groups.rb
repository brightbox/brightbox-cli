module Brightbox
  class ServerGroup < Api

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
      [:id, :server_count, :name]
    end

    def firewall_policy
      FirewallPolicy.all.detect do |policy|
        policy.server_group_id == self.id
      end
    end

    def update(options)
      self.class.conn.update_server_group(id, options)
      self.reload
      self
    end

    def destroy
      fog_model.destroy
    end

    def attributes
      fog_model.attributes
    end

    def to_row
      o = attributes
      o[:servers] = server_string
      o[:server_count] = server_count
      o
    end

    def server_count
      server_ids.respond_to?(:size) ? server_ids.size : 0
    end

    def server_string
      server_ids.respond_to?(:join) ? server_ids.join(" ") : ""
    end

    def server_ids
      if attributes["servers"]
        @server_ids ||= attributes["servers"].collect { |s| s["id"] }
      end
    end

  end
end
