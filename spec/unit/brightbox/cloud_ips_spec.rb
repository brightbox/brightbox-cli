require "spec_helper"

describe Brightbox::CloudIP do
  subject(:cloud_ip) do
    Brightbox::CloudIP.new("cip-12345")
  end

  it_behaves_like "a wrapped API resource"
end
