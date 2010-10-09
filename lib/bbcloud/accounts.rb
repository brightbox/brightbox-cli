module Brightbox
  class Account < Api

    def initialize(h)
      @fog_model = h
      @id = h["id"]
    end

    def attributes
      fog_model
    end

    def to_row
      attributes
    end

    def self.all
      conn.users.first.accounts.collect { |a| new(a) }
    end

    def self.get(id)
      all.find { |a| a.id == id }
    end

    def self.default_field_order
      ["id", "name", "ram_limit", "ram_used"]
    end

    def to_s
      @id
    end

  end
end
