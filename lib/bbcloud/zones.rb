module Fog
  module Brightbox
    class Compute
      class Zone
        def to_row
          o = { }
          o[:id] = id 
					o[:name] = name
          o
        end
      end
    end
  end
end
