require "spec_helper"

RSpec.describe Brightbox::Type, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Model",
      id: "typ-12345",
      attributes: model_attributes,
      ram: 1_024,
      disk: 10_240
    )
  end
  let(:model_attributes) { { id: "typ-12345" } }

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
