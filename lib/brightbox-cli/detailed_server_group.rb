module Brightbox
  class DetailedServerGroup < ServerGroup
    def to_row
      row_attributes = attributes
      row_attributes[:firewall_policy] = firewall_policy && firewall_policy.id
      row_attributes.to_h
    end

    def self.default_field_order
      %i[id name servers firewall_policy description]
    end
  end
end
