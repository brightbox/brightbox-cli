require "spec_helper"

describe "brightbox volumes show" do
  include VolumeHelpers

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
    let(:argv) { %w[volumes show] }

    it "reports missing IDs" do
      expect { output }.to_not raise_error

      aggregate_failures do
        expect(stderr).to match("ERROR: You must specify volume IDs to show")
        expect(stdout).to be_empty
      end
    end
  end

  context "with identifier argument" do
    let(:argv) { %w[volumes show vol-88878] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-88878")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-88878",
            description: "A volume for testing",
            filesystem_type: "ext4",
            storage_type: "network",
            size: 10_240,
            status: "attached",
            server: nil
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id: vol-88878")
        expect(stdout).to match("status: attached")
        expect(stdout).to match("created_at: 2023-01-01T01:01Z")
        expect(stdout).to match("description: A volume for testing")
        expect(stdout).to match("zone: zon-12345")
        expect(stdout).to match("size: 10240")
        expect(stdout).to match("type: network")
        expect(stdout).to match("server:")
        expect(stdout).to match("boot: false")
        expect(stdout).to match("filesystem_label:")
        expect(stdout).to match("filesystem_type: ext4")
        expect(stdout).to match("delete_with_server: false")
        expect(stdout).to match("encrypted: false")
        expect(stdout).to match("serial: vol-12345")
        expect(stdout).to match("source:")
        expect(stdout).to match("image: img-12345")
        expect(stdout).to match("locked: false")
      end
    end
  end

  context "with multiple identifiers" do
    let(:argv) { %w[volumes show vol-88878 vol-99999] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-88878")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-88878",
            description: "A volume for testing",
            filesystem_type: "ext4",
            storage_type: "network",
            size: 10_240,
            status: "attached",
            server: nil
          )
        )

      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-99999")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-99999",
            description: "Another volume for testing",
            filesystem_type: "ext4",
            storage_type: "network",
            size: 10_240,
            status: "attached",
            server: nil
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).not_to match("ERROR")

      aggregate_failures do
        expect(stdout).to match("id: vol-88878")
        expect(stdout).to match("id: vol-99999")
      end
    end
  end
end
