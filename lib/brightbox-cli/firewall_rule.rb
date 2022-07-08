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
      t = @attributes || fog_model.attributes
      t[:sport] = t[:source_port]
      t[:dport] = t[:destination_port]
      t[:firewall_policy] = t[:firewall_policy_id]
      t[:icmp_type] = t[:icmp_type_name]
      t
    end

    def to_row
      attrs = attributes.dup
      %i[protocol source sport destination dport icmp_type].each do |key|
        attrs[key] = attributes[key] || "-"
      end
      attrs
    end

    def ret_val(attributes, key)
      attributes[key] || "-"
    end

    def self.default_field_order
      %i[id protocol source sport destination dport icmp_type description]
    end
  end
end
