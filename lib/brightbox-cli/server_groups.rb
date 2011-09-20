module Brightbox
  class ServerGroup < Api

    def self.create(options)
      new(conn.server_groups.create(options))
    end

    def attributes
      a = fog_model.attributes
      a
    end

    def to_row
      o = attributes
      o[:servers] = server_ids
      o
    end

    def server_ids
      @server_ids ||= attributes["servers"].collect { |s| s["id"] } if attributes["servers"]
    end

    def destroy
      fog_model.destroy
    rescue Excon::Errors::Conflict => e
      raise Conflict, "Cannot delete server group #{id}"
    end

    def self.get(id)
      conn.server_groups.get(id)
    end

    def self.all
      conn.server_groups
    end

    def self.default_field_order
      [:id, :name, :servers, :description]
    end

  end
end
