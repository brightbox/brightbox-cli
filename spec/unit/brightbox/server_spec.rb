require "spec_helper"

describe Brightbox::Server do
  subject(:server) do
    Brightbox::Server.new("srv-12345")
  end

  it_behaves_like "a wrapped API resource"
end
