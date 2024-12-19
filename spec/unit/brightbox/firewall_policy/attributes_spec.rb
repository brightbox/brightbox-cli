require "spec_helper"

RSpec.describe Brightbox::FirewallPolicy, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Model",
      id: "res-12345",
      attributes: model_attributes,
      description: "",
      server_group_id: "grp-12345",
      name: "my-policy"
    )
  end
  let(:model_attributes) { { id: "fwp-12345" } }

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
