require "spec_helper"

describe "brightbox volumes update" do
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
    let(:argv) { %w[volumes update] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify the volume ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "with new options" do
    let(:argv) { %w[volumes update --name New --desc Testing --serial 12345 vol-908us] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-908us")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-908us",
          name: "Old",
          description: nil,
          serial: "vol-908us"
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-908us",
          name: "New",
          description: "Testing",
          delete_with_server: true,
          serial: "12345"
        )
      )

      stub_request(:put, "http://api.brightbox.localhost/1.0/volumes/vol-908us")
        .with(query: hash_including(account_id: "acc-12345"),
              body: {
                name: "New",
                description: "Testing",
                serial: "12345"
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-908us",
            name: "New",
            description: "Testing",
            delete_with_server: true,
            serial: "12345"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating vol-908us\n")

      aggregate_failures do
        expect(stdout).to match("vol-908us")
        expect(stdout).to match("New")
      end
    end
  end

  context "with delete-with-server option" do
    let(:argv) { %w[volumes update --delete-with-server vol-kl234] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-kl234")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-kl234",
          delete_with_server: false
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-kl234",
          delete_with_server: true
        )
      )

      stub_request(:put, "http://api.brightbox.localhost/1.0/volumes/vol-kl234")
        .with(query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: true
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-kl234",
            delete_with_server: true
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating vol-kl234\n")

      aggregate_failures do
        expect(stdout).to match("vol-kl234")
        expect(stdout).to match("false")
      end
    end
  end

  context "with no-delete-with-server option" do
    let(:argv) { %w[volumes update --no-delete-with-server vol-sdj2j] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-sdj2j")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-sdj2j",
          delete_with_server: true
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-sdj2j",
          delete_with_server: false
        )
      )

      stub_request(:put, "http://api.brightbox.localhost/1.0/volumes/vol-sdj2j")
        .with(query: hash_including(account_id: "acc-12345"),
              body: {
                delete_with_server: false
              })
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-sdj2j",
            delete_with_server: false
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Updating vol-sdj2j\n")

      aggregate_failures do
        expect(stdout).to match("vol-sdj2j")
        expect(stdout).to match("false")
      end
    end
  end
end
