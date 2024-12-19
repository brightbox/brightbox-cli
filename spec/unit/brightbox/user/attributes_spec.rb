require "spec_helper"

RSpec.describe Brightbox::User, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double("Fog::Model", id: "res-12345", attributes: { id: "res-12345"})
  end

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
