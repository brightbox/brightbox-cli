module Brightbox
  class Type < Api
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
      [:id, :name, :handle, :ram, :disk, :cores]
    end

    def <=>(other)
      if other.is_a? Type
        ram <=> other.ram
      else
        ram <=> other
      end
    end
  end
end
