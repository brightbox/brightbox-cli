module Brightbox
  class DatabaseType < Api
    def self.require_account?; true; end

    def attributes
      o = fog_model.attributes
      o[:ram] = ram
      o[:disk] = disk
      o
    end

    def ram
      fog_model.ram.to_i
    end

    def disk
      fog_model.disk.to_i
    end

    def to_row
      attributes
    end

    def self.all
      conn.database_types
    end

    def self.get(id)
      conn.database_types.get id
    end

    def self.default_field_order
      [:id, :name, :ram, :disk]
    end

    def <=>(other)
      if other.is_a? DatabaseType
        ram <=> other.ram
      else
        ram <=> other
      end
    end
  end
end
