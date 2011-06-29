# Hack to force persistent connections in fog
module Fog
  class Connection
    def initialize(url, persistent=false)
      @excon = Excon.new(url)
      @persistent = true
    end
  end
end

module Fog
  module Brightbox
    class Compute
      class Real
        attr_accessor :oauth_token
      end
    end
  end
end
