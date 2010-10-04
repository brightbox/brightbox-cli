module Fog
  module Brightbox
    class Compute
      class Flavor
        def to_row
          o = { }
          o[:id] = id 
					o[:status] = status
          o[:ram] = ram
          o[:disk] = disk.to_i
          o[:cores] = cores
          o[:name] = name
					o[:description] = description
          o
        end
      end
    end
  end
end
