require "spec_helper"

describe Brightbox::FirewallPolicy do
  subject(:policy) do
    Brightbox::FirewallPolicy.new("fwp-12345")
  end

  it_behaves_like "a wrapped API resource"
end
