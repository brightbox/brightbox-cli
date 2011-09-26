module Brightbox
  class FirewallRule < Api
    attr_writer :attributes

    def self.create(options)
      new(conn.firewall_rules.create(options))
    end

    def self.get(id)
      conn.firewall_rules.get(id)
    end

    def attributes
      t = @attributes || fog_model.attributes
      t[:sport] = t[:source_port]
      t[:dport] = t[:destination_port]
      t
    end

    def to_row
      attributes
    end

    def self.default_field_order
      [:id, :protocol,:source, :sport,:destination, :dport, :icmp_type_name]
    end
  end
end
