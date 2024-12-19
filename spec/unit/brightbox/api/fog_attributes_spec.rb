require "spec_helper"

RSpec.describe Brightbox::Api, "#fog_attributes" do
  subject(:model_attributes) { api_model.fog_attributes }

  let(:api_model) { Brightbox::Api.new(fog_model) }
  let(:fog_model) do
    double(
      "Fog::Compute::Brightbox::Api",
      id: "res-12345",
      attributes: attributes
    )
  end

  context "when attributes are not set" do
    let(:attributes) { nil }

    it "returns an indifferent access hash" do
      expect(model_attributes).to be_instance_of(IndifferentAccessHash)
    end
  end

  context "when attributes are set with a mix of string and symbols" do
    let(:attributes) do
      {
        id: "res-12345",
        name: "test",
        acme: acme_details
      }
    end
    let(:acme_details) do
      {
        "domains" => [
          {
            "identifier" => "example.test",
            "status" => "pending"
          }
        ]
      }
    end

    it "transforms the keys with deep symbolize" do
      expect(model_attributes).to eq(
        id: "res-12345",
        name: "test",
        acme: {
          domains: [
            {
              identifier: "example.test",
              status: "pending"
            }
          ]
        }
      )
    end

    it "can not accessed by string keys" do
      expect(model_attributes["acme"]["domains"].first["identifier"]).to eq("example.test")
    end

    it "can accessed by symbol keys" do
      expect(model_attributes[:acme][:domains].first[:identifier]).to eq("example.test")
    end
  end
end
