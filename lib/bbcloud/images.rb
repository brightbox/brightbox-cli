class Image

  def self.find(list = [])
    if list.empty?
      Api.conn.images
    else
      list.uniq.collect do |i|
        image = Api.conn.images.get i
        image = { :id => i, :status => 'NaN' } if image.nil?
        image
      end
    end
  end

end

module Fog
  module Brightbox
    class Compute
      class Image
        def to_row
          o = { }
          o[:id] = id 
          o[:status] = status
          o[:access] = (public ? 'public' : 'private')
          o[:arch] = arch
          o[:name] = name
          o[:type] = source_type
          o
        end
      end
    end
  end
end
