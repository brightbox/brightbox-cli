module Brightbox
  class Volume < Api
    def self.require_account?; true; end

    def self.all
      conn.volumes
    end

    def self.create(options)
      new(conn.volumes.create(options))
    end

    def self.get(id)
      conn.volumes.get(id)
    end

    def self.default_field_order
      %i[
        id
        type
        size
        status
        server
        boot
        name
      ]
    end

    def self.detailed_fields
      %i[
        id
        name
        description
        type
        size
        status
        created_at
        encrypted
        serial
        locked
        filesystem_label
        filesystem_type
        image
        source
        source_type
        server
        boot
        delete_with_server
        zone
      ]
    end

    def attach(server:, boot: false)
      self.class.conn.attach_volume(id, server: server, boot: boot)
      reload
      self
    end

    def attributes
      super.merge(
        id: fog_model.id,
        image: image_id,
        locked: locked?,
        server: server_id,
        status: state,
        type: storage_type,
        zone: zone_id
      )
    end

    def update(options)
      self.class.conn.update_volume(id, options)
      reload
      self
    end
  end
end
