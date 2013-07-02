require "spec_helper"

describe Brightbox::DetailedServerGroup do
  subject(:server_group) do
    Brightbox::DetailedServerGroup.new("grp-12345")
  end

  it_behaves_like "a wrapped API resource"
end
