require "spec_helper"

describe Brightbox::Zone do
  subject(:zone) do
    Brightbox::Zone.new("zon-12345")
  end

  it_behaves_like "a wrapped API resource"
end
