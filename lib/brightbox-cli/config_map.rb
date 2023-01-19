module Brightbox
  class ConfigMap < Api
    def self.require_account?; true; end

    def self.all
      conn.config_maps
    end

    def self.create(options)
      new(conn.config_maps.create(options))
    end

    def self.get(id)
      conn.config_maps.get(id)
    end

    def self.default_field_order
      %i[id name]
    end

    def self.detailed_fields
      %i[
        id
        name
      ]
    end

    def format_data(format)
      case format.to_sym
      when :text
        attributes[:data].map do |key, value|
          "#{key.to_s.rjust(16)}: #{value}"
        end.join("\n")
      else
        JSON.dump(data)
      end
    end

    def to_row
      {
        id: attributes[:id],
        name: attributes[:name],
        data: attributes[:data]
      }
    end

    def update(options)
      self.class.conn.update_config_map(id, options)
      reload
      self
    end
  end
end
