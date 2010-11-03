module Brightbox
  class Image < Api
    
    def to_row
      o = fog_model.attributes
      o[:id] = fog_model.id 
      status_row = [status]
      status_row << (public ? 'public' : 'private')
      o[:status] = status_row.join '/'
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
      o
    end

    def public?
      public
    end

    def self.all
      conn.images
    end

    def self.get(id)
      conn.images.get(id)
    end

    def self.default_field_order
      [:id, :owner, :type, :created_on, :status, :name]
    end
  end
end
