require "spec_helper"

RSpec.describe Brightbox::LoadBalancer, "#acme_cert" do
  subject(:acme_cert) { load_balancer.acme_cert }

  let(:fog_model) do
    double(
      "Fog::Compute::Brightbox::LoadBalancer",
      id: "lba-12345",
      attributes: lba_attributes
    )
  end
  let(:load_balancer) { Brightbox::LoadBalancer.new(fog_model) }

  context "when ACME is not setup" do
    let(:lba_attributes) { { acme: nil } }

    it "returns an empty string" do
      expect(acme_cert).not_to be_nil
    end
  end

  context "when ACME is setup" do
    context "without certificate" do
      let(:lba_attributes) do
        { acme: { certificate: nil }}
      end

      it "returns an object without keys" do
        expect(acme_cert).not_to be_nil

        expect(acme_cert).to have_attributes(
          expires_at: "",
          fingerprint: "",
          issued_at: "",
          subjects: ""
        )
      end
    end

    context "with certificate" do
      let(:expected_formatting) { "example.com:verified,example.net:pending" }
      let(:lba_attributes) do
        {
          acme: {
            domains: [
              { identifier: "domain.one.test", status: "verified" },
              { identifier: "domain.two.test", status: "verified" }
            ],
            certificate: {
              domains: [
                "domain.one.test",
                "domain.two.test"
              ],
              expires_at: "2025-12-31T23:59:59Z",
              fingerprint: "TLS-fingerprint",
              issued_at: "2025-01-01T00:00:00Z"
            }
          }
        }
      end

      it "returns an object with the correct keys" do
        expect(acme_cert).not_to be_nil

        expect(acme_cert).to have_attributes(
          expires_at: "2025-12-31T23:59:59Z",
          fingerprint: "TLS-fingerprint",
          issued_at: "2025-01-01T00:00:00Z",
          subjects: "domain.one.test,domain.two.test"
        )
      end
    end
  end
end
