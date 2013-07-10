require "spec_helper"

describe Brightbox::ServerGroup do
  subject(:group) do
    Brightbox::ServerGroup.new("grp-12345")
  end

  it_behaves_like "a wrapped API resource"
end
