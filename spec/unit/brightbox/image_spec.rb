require "spec_helper"

describe Brightbox::Image do
  subject(:image) do
    Brightbox::Image.new("img-12345")
  end

  it_behaves_like "a wrapped API resource"
end
