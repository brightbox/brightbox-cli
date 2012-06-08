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

    # Filter out images that are not of the right type, account or status if the option is passed
    def self.filter_images(images, options={})
      # Remove images that don't match the given type
      if options[:t]
        images.reject! { |i| i.type != options[:t] }
      end

      # Remove statuses that don't match the argument
      if options[:s]
        images.reject! { |i| i.status != options[:s] }
      end

      # Remove images that don't belong to the specified owner id
      if options[:l]
        if options[:l] == 'brightbox'
          images.reject! { |i| !i.official }
        else
          images.reject! { |i| i.owner_id != options[:l] }
        end
      end

      unless options[:a]
        account = Account.conn_account
        images.reject! { |i| !i.official and i.owner_id != account.id  }
      end

      snapshots = images.select { |i| i.source_type == 'snapshot' }
      images = images - snapshots

      images.sort! { |a, b| a.default_sort_fields <=> b.default_sort_fields }
      snapshots.sort! { |a, b| a.created_at <=> b.created_at }
      images + snapshots
    end

    def update options
      self.class.conn.update_image(id, options)
      self.reload
      self
    end

    def type
      if official
        "official"
      else
        source_type
      end
    end

    def status
      if fog_model.attributes[:status] == "available"
        public ? 'public' : 'private'
      else
        fog_model.attributes[:status]
      end
    end

    def to_row
      o = fog_model.attributes
      o[:id] = fog_model.id
      o[:status] = status
      o[:username] = username
      o[:arch] = arch
      o[:name] = name.to_s + " (#{arch})"
      o[:owner] = owner_id
      o[:owner] = "brightbox" if official
      o[:type] = type
      o[:created_at] = created_at
      o[:created_on] = created_at.to_s.split('T').first
      o[:description] = description if description
      o[:licence_name] = licence_name
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
