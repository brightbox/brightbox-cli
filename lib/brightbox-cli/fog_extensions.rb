Fog::Compute::Brightbox::Real.class_eval do |klass|
  klass.send(:attr_accessor, :oauth_token)
end
