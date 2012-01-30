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
    end

    def to_row
      o = fog_model.attributes
      o[:id] = fog_model.id
      if status == "available"
        o[:status] = (public ? 'public' : 'private')
      else
        o[:status] = status
      end
      o[:username] = username
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

    def status_sort_code
      case self.status
      when 'available'
        (self.public ? 1 : 2)
      when 'deprecated'
        3
      else
        4
      end
    end

    def default_sort_fields
      [
        self.official ? 0 : 1,
        self.name,
        self.arch,
        self.status_sort_code,
        - self.created_at.to_i
      ]
    end

  end
end
