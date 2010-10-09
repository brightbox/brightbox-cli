module Brightbox
  class Image < Api
    
    def to_row
      o = { }
      o[:id] = fog_model.id 
      o[:status] = status
      o[:access] = (public ? 'public' : 'private')
      o[:arch] = arch
      o[:name] = name
      o[:type] = source_type
      o[:created_at] = created_at
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
      [:id, :type, :created_at, :status, :access, :arch, :name]
    end
  end
end
