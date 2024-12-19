require "spec_helper"

RSpec.describe Brightbox::CloudIP, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Model",
      id: "cip-12345",
      destination_id: nil,
      attributes: model_attributes
    )
  end
  let(:model_attributes) { { id: "cip-12345" } }

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
