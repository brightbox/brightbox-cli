module Brightbox
  class DetailedServerGroup < ServerGroup
    def to_row
      row_attributes = super
      row_attributes[:firewall_policy] = firewall_policy && firewall_policy.id
      row_attributes
    end

    def self.default_field_order
      [:id, :name, :servers, :firewall_policy, :description]
    end
  end
end
