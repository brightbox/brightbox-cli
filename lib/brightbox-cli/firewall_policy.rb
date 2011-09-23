module Brightbox
  class FirewallPolicy < Api
    def self.get(id)
      conn.firewall_policy.get(id)
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
      [:id, :server_group, :default,:name]
    end
  end
end
