require "spec_helper"

describe Brightbox::LoadBalancer do
  subject(:balancer) do
    Brightbox::LoadBalancer.new("lba-12345")
  end

  it_behaves_like "a wrapped API resource"
end
