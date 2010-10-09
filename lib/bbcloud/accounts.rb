module Brightbox
  class Account < Api

    def initialize(h)
      @fog_model = h
      @id = h["id"]
    end

    def attributes
      fog_model.merge({ "ram_free" => ram_free })

    end

    def ram_free
      [fog_model['ram_limit'].to_i - fog_model['ram_used'].to_i, 0].max
    end

    def to_row
      attributes
    end

    def self.all
      conn.users.first.accounts.collect { |a| a }
    end

    def self.get(id)
      all.find { |a| a.id == id }
    end

    def self.default_field_order
      ["id", "name", "ram_limit", "ram_used", "ram_free"]
    end

    def to_s
      @id
    end

  end
end
