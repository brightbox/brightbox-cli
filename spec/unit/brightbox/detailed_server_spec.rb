require "spec_helper"

describe Brightbox::DetailedServer do
  subject(:server) do
    Brightbox::DetailedServer.new("srv-12345")
  end

  it_behaves_like "a wrapped API resource"
end
