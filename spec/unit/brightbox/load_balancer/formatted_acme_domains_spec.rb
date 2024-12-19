require "spec_helper"

RSpec.describe Brightbox::LoadBalancer, "#formatted_acme_domains" do
  subject(:load_balancer) { Brightbox::LoadBalancer.new(fog_model) }

  let(:fog_model) do
    double(
      "Fog::Compute::Brightbox::LoadBalancer",
      id: "lba-12345",
      attributes: lba_attributes
    )
  end
  let(:lba_attributes) do
    # Encode/decode JSON to get final key/value forms
    JSON.parse({
      id: "lba-12345",
      acme: acme_details
    }.to_json)
  end

  context "when ACME is not setup" do
    let(:acme_details) { nil }

    it "returns an empty array" do
      expect(load_balancer.formatted_acme_domains).to eq("")
    end
  end

  context "when no domains are returned" do
    let(:acme_details) do
      { domains: [] }
    end

    it "returns an empty array" do
      expect(load_balancer.formatted_acme_domains).to eq("")
    end
  end

  context "when multiple domains are returned" do
    let(:acme_details) do
      {
        domains: [
          {
            identifier: "example.com",
            status: "verified"
          },
          {
            identifier: "example.net",
            status: "pending"
          }
        ]
      }
    end
    let(:expected_formatting) do
      "example.com:verified,example.net:pending"
    end

    it "returns a comma separated list of domains and statuses" do
      expect(load_balancer.formatted_acme_domains).to eq(expected_formatting)
    end
  end

  context "when error occurs" do
    let(:lba_attributes) do
      # Encode/decode JSON to get final key/value forms
      JSON.parse({
        id: "lba-12345",
        acme: {
          domains: nil
        }
      }.to_json)
    end

    it "returns an empty array" do
      expect(load_balancer.formatted_acme_domains).to eq("")
    end
  end
end
