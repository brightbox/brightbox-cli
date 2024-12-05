module Brightbox
  class Image < Api
    def self.require_account?; true; end

    def self.all
      conn.images
    end

    def self.get(id)
      conn.images.get(id)
    end

    def self.register(options = {})
      image = conn.create_image(options)
      find image["id"]
    end

    def self.default_field_order
      %i[id owner type created_on status size arch name]
    end

    # Filter out images that are not of the right type, account or status if the option is passed
    def self.filter_images(images, options = {})
      # Remove images that don't match the given type
      if options[:t]
        images.select! { |i| i.type == options[:t] }
      end

      # Remove statuses that don't match the argument
      if options[:s]
        images.select! { |i| i.status == options[:s] }
      end

      # Remove images that don't belong to the specified owner id
      if options[:l]
        if options[:l] == "brightbox"
          images.select!(&:official)
        else
          images.select! { |i| i.owner_id == options[:l] }
        end
      end

      unless options[:a]
        account = Account.conn.get_scoped_account(:nested => false)
        images.reject! { |i| !i.official && i.owner_id != account["id"] }
      end

      snapshots = images.select { |i| i.source_type == "snapshot" }
      images -= snapshots

      images.sort! { |a, b| a.default_sort_fields <=> b.default_sort_fields }
      snapshots.sort! { |a, b| a.created_at <=> b.created_at }
      images + snapshots
    end

    def update(options)
      self.class.conn.update_image(id, options)
      reload
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
      if fog_attributes[:status] == "available"
        public? ? "public" : "private"
      elsif fog_attributes[:status] == "deprecated"
        public? ? "deprecated" : "private"
      else
        fog_attributes[:status]
      end
    end

    def to_row
      fog_attributes.merge(
        id: fog_model.id,
        status: status,
        locked: locked?,
        username: username,
        arch: arch,
        name: name.to_s,
        owner: official ? "brightbox" : owner_id,
        type: type,
        created_at: created_at,
        created_on: created_on,
        description: description,
        licence_name: licence_name,
        size: virtual_size,
        min_ram: min_ram
      )
    end

    def public?
      public
    end

    def status_sort_code
      case fog_attributes[:status]
      when "available"
        (public? ? 1 : 2)
      when "deprecated"
        3
      else
        4
      end
    end

    def default_sort_fields
      [
        official ? 0 : 1,
        name,
        arch,
        status_sort_code,
        - created_at.to_i
      ]
    end
  end
end
