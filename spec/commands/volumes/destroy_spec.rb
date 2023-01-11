require "spec_helper"

describe "brightbox volumes destroy" do
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
    let(:argv) { %w[volumes destroy] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify volume IDs as arguments\n")

      expect(stdout).to match("")
    end
  end

  context "with one argument" do
    let(:argv) { %w[volumes destroy vol-ui342] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-ui342")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-ui342",
            status: "detached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-ui342",
            status: "detached",
            boot: false,
            server: nil
          )
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/volumes/vol-ui342")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-ui342",
            status: "detached",
            server: {
              id: "srv-03431"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Destroying vol-ui342\n")

      expect(stdout).to eq("")
    end
  end

  context "with multiple arguments" do
    let(:argv) { %w[volumes destroy vol-o2342 vol-3422f] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-o2342")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-o2342",
            status: "detached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-o2342",
            status: "detached",
            boot: false,
            server: nil
          )
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/volumes/vol-o2342")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-o2342",
            status: "detached",
            server: {
              id: "srv-03431"
            }
          )
        )

        stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-3422f")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-3422f",
            status: "detached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-3422f",
            status: "detached",
            boot: false,
            server: nil
          )
        )

      stub_request(:delete, "http://api.brightbox.localhost/1.0/volumes/vol-3422f")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-3422f",
            status: "detached",
            server: {
              id: "srv-03431"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Destroying vol-o2342\n")
      expect(stderr).to match("Destroying vol-3422f\n")

      expect(stdout).to eq("")
    end
  end
end
