module Brightbox
  class ServerGroup < Api

    def self.create_server_groups(count,options)
      (0...count).map {|i| create(options) }
    end

    def self.create(options)
      new(conn.server_groups.create(options))
    end

    def attributes
      a = fog_model.attributes
      a[:image] = image
      a[:created_at] = created_at
      a[:created_on] = fog_model.created_at.strftime("%Y-%m-%d")
      a
    end

    def to_row
      o = attributes
      o[:servers] = servers.collect { |i| i['id'] }
      o
    end

    # def deleted?
    #   fog_model.status == "deleted"
    # end

    def destroy
      fog_model.destroy
    rescue Excon::Errors::Conflict => e
      raise Conflict, "Cannot delete server group #{id}"
    end

    def self.get(id)
      conn.server_groups.get id
    end

    def self.all
      conn.list_server_groups
    end

    def self.default_field_order
      [:id, :name, :servers, :description]
    end

  end
end
