# Hack to force persistent connections in fog
module Fog
  class Connection
    def initialize(url, persistent=false)
      @excon = Excon.new(url)
      @persistent = true
    end
  end
end

Fog::Compute::Brightbox::Real.class_eval do |klass|
  klass.send(:attr_accessor, :oauth_token)
end
