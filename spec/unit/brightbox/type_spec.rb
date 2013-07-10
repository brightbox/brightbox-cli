require "spec_helper"

describe Brightbox::Type do
  subject(:server_type) do
    Brightbox::Type.new("typ-12345")
  end

  it_behaves_like "a wrapped API resource"
end
