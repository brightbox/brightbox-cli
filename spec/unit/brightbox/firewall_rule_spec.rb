require "spec_helper"

describe Brightbox::FirewallRule do
  subject(:rule) do
    Brightbox::FirewallRule.new("fwr-12345")
  end

  it_behaves_like "a wrapped API resource"
end
