require "pp"
module Brightbox
  class FirewallRule < Api
    def self.require_account?; true; end
    attr_writer :attributes

    def self.create(options)
      new(conn.firewall_rules.create(options))
    end

    def self.get(id)
      conn.firewall_rules.get(id)
    end

    def update(params)
      self.class.conn.update_firewall_rule id, params
      reload
      self
    end

    def attributes
      (@attributes || fog_attributes).tap do |attrs|
        attrs[:sport] = attrs[:source_port]
        attrs[:dport] = attrs[:destination_port]
        attrs[:firewall_policy] = attrs[:firewall_policy_id]
        attrs[:icmp_type] = attrs[:icmp_type_name]
      end
    end

    def to_row
      attributes.merge(
        protocol: attributes[:protocol] || "-",
        source: attributes[:source] || "-",
        sport: attributes[:sport] || "-",
        destination: attributes[:destination] || "-",
        dport: attributes[:dport] || "-",
        icmp_type: attributes[:icmp_type] || "-"
      )
    end

    def self.default_field_order
      %i[id protocol source sport destination dport icmp_type description]
    end
  end
end
