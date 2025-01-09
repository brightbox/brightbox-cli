require "spec_helper"

describe "brightbox servers" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      WebMock.reset!

      config_from_contents(API_CLIENT_CONFIG_CONTENTS)
      stub_client_token_request
      Brightbox.config.reauthenticate
    end

    context "without arguments" do
      let(:argv) { %w[servers show] }

      it "reports missing IDs" do
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).to match("ERROR: You must specify server IDs to show")
          expect(stdout).to be_empty
        end
      end
    end

    context "with identifier argument" do
      let(:argv) { %w[servers show srv-55555] }

      before do
        stub_request(:get, "#{api_url}/1.0/images")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              images: [
                {
                  id: "img-12345",
                  min_ram: 2_048
                }
              ]
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/images/img-12345")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "img-12345"
            }.to_json
          )

        stub_request(:get, "#{api_url}/1.0/servers/srv-55555")
          .with(query: hash_including(account_id: "acc-12345"))
          .to_return(
            status: 200,
            body: {
              id: "srv-12345",
              name: "app-server1",
              status: "active",
              image: {
                id: "img-12345"
              },
              server_type: {
                id: "typ-12345"
              },
              cloud_ips: [],
              interfaces: [
                {
                  id: "int-12345",
                  ipv4_address: "10.0.0.0",
                  ipv6_address: "2a02:1234:abcd:5678::1"
                }
              ],
              server_groups: [],
              snapshots: []
            }.to_json
          )
      end

      it "does not error" do
        require "pry"
        # binding.pry
        expect { output }.to_not raise_error

        aggregate_failures do
          expect(stderr).not_to match("ERROR")
          expect(stdout).to match("id: srv-12345")
          expect(stdout).to match("status: active")
          expect(stdout).to match("name: app-server1")
        end
      end
    end
  end
end
