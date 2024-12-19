require "spec_helper"

RSpec.describe Brightbox::Server, "#attributes" do
  subject { described_class.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Model",
      id: "srv-12345",
      attributes: model_attributes,
      cloud_ips: [],
      created_at: Time.parse("2025-01-01T12:00:00Z"),
      created_on: "2025-01-01",
      hostname: "srv-12345.gb1.brightbox.com",
      image_id: "img-12345",
      interfaces: [],
      locked?: false,
      type: "typ-12345",
      state: "active",
      server_type: "typ-12345",
      zone: { id: "zon-12345", handle: "gb1-a" }
    )
  end
  let(:model_attributes) { { id: "srv-12345" } }

  it "returns an IndifferentAccessHash" do
    expect(subject.attributes).to be_a(IndifferentAccessHash)
  end
end
