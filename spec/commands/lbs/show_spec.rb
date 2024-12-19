require "spec_helper"

describe "brightbox lbs" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "without identifier argument" do
      let(:argv) { %w[lbs show] }
      let(:json_response) do
        <<~EOS
        [
          {
            "id":"lba-12345",
            "name":"app-lb1",
            "status":"active",
            "created_at":"2012-03-05T12:00:00Z",
            "nodes":[
              {
                "id":"srv-12345",
                "status":"active"
              }
            ]
          }
        ]
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/load_balancers?account_id=acc-12345")
          .to_return(:status => 200, :body => json_response)
      end

      it "shows load balancer details" do
        aggregate_failures do
          expect(stderr).to be_empty unless ENV["DEBUG"]
          expect(stdout).to include("id: lba-12345")
          expect(stdout).to include("status: active")
          expect(stdout).to include("name: app-lb1")
          expect(stdout).to include("created_at: 2012-03-05T12:00Z")
          expect(stdout).to include("nodes: srv-12345")
        end
      end
    end

    context "with identifier argument" do
      let(:argv) { %w[lbs show lba-12345] }
      let(:json_response) do
        <<~EOS
        {
          "id":"lba-12345",
          "name":"app-lb1",
          "status":"active",
          "created_at":"2012-03-05T12:00:00Z",
          "acme": {
            "domains": [
              {
                "identifier": "domain.test",
                "status": "verified"
              },
              {
                "identifier": "domain2.test",
                "status": "verified"
              }
            ],
            "certificate": {
              "domains": [
                "domain.test"
              ],
              "expires_at": "2025-12-31T23:59:59Z",
              "fingerprint": "fingerprint",
              "issued_at": "2025-01-01T00:00:00Z"
            }
          },
          "nodes":[
            {
              "id":"srv-12345",
              "status":"active"
            }
          ]
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/load_balancers/lba-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => json_response)
      end

      it "shows load balancer details" do
        aggregate_failures do
          expect(stderr).to be_empty unless ENV["DEBUG"]
          expect(stdout).to include("id: lba-12345")
          expect(stdout).to include("status: active")
          expect(stdout).to include("name: app-lb1")
          expect(stdout).to include("created_at: 2012-03-05T12:00Z")
          expect(stdout).to include("nodes: srv-12345")
          expect(stdout).to include("acme_domains: domain.test:verified,domain2.test:verified")
          expect(stdout).to include("acme_cert_subjects: domain.test")
          expect(stdout).to include("acme_cert_expires_at: 2025-12-31T23:59:59Z")
          expect(stdout).to include("acme_cert_fingerprint: fingerprint")
          expect(stdout).to include("acme_cert_issued_at: 2025-01-01T00:00:00Z")
        end
      end
    end
  end
end
