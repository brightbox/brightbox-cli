module Brightbox
  class FirewallPolicy < Api

    def self.create(options)
      new(conn.firewall_policies.create(options))
    end

    def self.get(id)
      conn.firewall_policies.get(id)
    end

    def self.all
      conn.firewall_policies
    end

    def attributes
      t = fog_model.attributes
      t[:name] = name
      t[:description] = description
      t[:server_group] = server_group_id
      t
    end

    def to_row
      attributes
    end

    def self.default_field_order
      [:id, :server_group, :name]
    end
  end
end
