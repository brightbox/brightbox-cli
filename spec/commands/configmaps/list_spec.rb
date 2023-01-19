require "spec_helper"

describe "brightbox configmaps list" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)

    stub_request(:post, "http://api.brightbox.localhost/token")
      .to_return(
        status: 200,
        body: JSON.dump(
          access_token: "ACCESS-TOKEN",
          refresh_token: "REFRESH_TOKEN"
        )
      )

    Brightbox.config.reauthenticate
  end

  context "without arguments" do
    let(:argv) { %w[configmaps list] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: config_maps_response
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("")

      aggregate_failures do
        expect(stdout).to match("id.*name")

        expect(stdout).to match("cfg-12345")
        expect(stdout).to match("Test 12345")

        expect(stdout).to match("cfg-abcde")
        expect(stdout).to match("Test ABCDE")
      end
    end
  end

  context "with identifier" do
    let(:argv) { %w[configmaps list cfg-312re] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/config_maps/cfg-312re")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "cfg-312re",
            name: "My config",
            data: {
              key: "value"
            }
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*name")

        expect(stdout).to match("cfg-312re")
        expect(stdout).to match("My config")
      end
    end
  end

  def config_maps_response
    [
      {
        id: "cfg-12345",
        name: "Test 12345"
      },
      {
        id: "cfg-abcde",
        name: "Test ABCDE"
      }
    ].to_json
  end
end
