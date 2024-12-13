require "spec_helper"

describe "brightbox volumes list" do
  include VolumeHelpers

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
    let(:argv) { %w[volumes list] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volumes_response
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to be_empty unless ENV["DEBUG"]

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-12345")
        expect(stdout).to match("network")
        expect(stdout).to match("10240")
        expect(stdout).to match("attached")
        expect(stdout).to match("srv-12345")
        expect(stdout).to match("false")

        expect(stdout).to match("vol-abcde")
        expect(stdout).to match("network")
        expect(stdout).to match("10240")
        expect(stdout).to match("attached")
        expect(stdout).to match("srv-12345")
        expect(stdout).to match("true")
      end
    end
  end

  context "with identifier" do
    let(:argv) { %w[volumes list vol-12345] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-12345")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-12345",
            storage_type: "network",
            size: 10_240,
            status: "attached",
            server: {
              id: "srv-12345"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id.*type.*size.*status.*server.*boot")

        expect(stdout).to match("vol-12345")
        expect(stdout).to match("network")
        expect(stdout).to match("10240")
        expect(stdout).to match("attached")
        expect(stdout).to match("srv-12345")
        expect(stdout).to match("false")
      end
    end
  end
end
