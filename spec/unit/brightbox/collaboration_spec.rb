require "spec_helper"

describe Brightbox::Collaboration do
  subject(:collaboration) do
    Brightbox::Collaboration.new("acc-12345")
  end

  it_behaves_like "a wrapped API resource"
end
