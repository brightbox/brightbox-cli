module Brightbox
  class Zone < Api
    def self.require_account?; true; end

    def to_row
      attributes
    end

    def self.all
      conn.zones
    end

    def self.get(id)
      conn.zones.get id
    end

    def self.default_field_order
      %i[id handle]
    end

    def to_s
      id
    end

    def render_cell
      handle
    end
  end
end
