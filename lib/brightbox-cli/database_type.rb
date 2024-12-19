module Brightbox
  class DatabaseType < Api
    def self.require_account?; true; end

    def attributes
      fog_attributes.tap do |attrs|
        attrs[:ram] = ram
        attrs[:disk] = disk
      end
    end

    def ram
      fog_model.ram.to_i
    end

    def disk
      fog_model.disk.to_i
    end

    def self.all
      conn.database_types
    end

    def self.get(id)
      conn.database_types.get id
    end

    def self.default_field_order
      %i[id name ram disk]
    end

    def <=>(other)
      ram <=> if other.is_a? DatabaseType
                other.ram
              else
                other
              end
    end
  end
end
