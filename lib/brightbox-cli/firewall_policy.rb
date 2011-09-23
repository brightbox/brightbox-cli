module Brightbox
  class FirewallPolicy < Api
    def self.get(id)
      conn.firewall_policy.get(id)
    end

    def self.all
      conn.firewall_policies
    end
  end
end
