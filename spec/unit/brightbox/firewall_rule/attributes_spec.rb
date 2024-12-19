require "spec_helper"

RSpec.describe Brightbox::FirewallRule, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Model",
      id: "fwr-12345",
      attributes: model_attributes
    )
  end
  let(:model_attributes) { { id: "fwr-12345" } }

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
