module Brightbox
  class Image < Api

    def self.all
      conn.images
    end

    def self.get(id)
      conn.images.get(id)
    end

    def self.register(options = {})
      image = conn.create_image(options)
      find image['id']
    end

    def self.default_field_order
      [:id, :owner, :type, :created_on, :status, :size, :name]
    end

    def update options
      self.class.conn.update_image(id, options)
      self.reload
      self
    rescue Excon::Errors::BadRequest => e
      raise Conflict, JSON.parse(e.response.body)['error']['details']
    end

    def to_row
      o = fog_model.attributes
      o[:id] = fog_model.id
      if status == "available"
        o[:status] = (public ? 'public' : 'private')
      else
        o[:status] = status
      end
      o[:arch] = arch
      o[:name] = name.to_s + " (#{arch})"
      o[:owner] = owner_id
      if official
        o[:type] = "official"
        o[:owner] = "brightbox"
      else
        o[:type] = source_type
      end
      o[:created_at] = created_at
      o[:created_on] = created_at.to_s.split('T').first
      o[:description] = description if description
      o[:size] = virtual_size
      o
    end

    def public?
      public
    end

  end
end
