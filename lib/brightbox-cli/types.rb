module Brightbox
  class Type < Api
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

    def render_cell
      fog_model.handle
    end

    def self.all
      conn.flavors
    end

    def self.get(id)
      conn.flavors.get id
    end

    def self.default_field_order
      %i[id name handle ram disk cores]
    end

    def <=>(other)
      ram <=> if other.is_a? Type
                other.ram
              else
                other
              end
    end
  end
end
