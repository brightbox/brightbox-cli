require "spec_helper"

describe "brightbox volumes detach" do
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
    let(:argv) { %w[volumes detach] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("ERROR: You must specify volume IDs as arguments\n")

      expect(stdout).to match("")
    end
  end

  context "with one argument" do
    let(:argv) { %w[volumes detach vol-dkl43] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-dkl43")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-dkl43",
            status: "attached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-dkl43",
            status: "detached",
            boot: false,
            server: nil
          )
        )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-dkl43/detach")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-dkl43",
            status: "detached",
            server: {
              id: "srv-03431"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to match("Detaching vol-dkl43\n")

      aggregate_failures do
        expect(stdout).to match("vol-dkl43")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end

  context "with multiple arguments" do
    let(:argv) { %w[volumes detach vol-p3241 vol-3422f] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-p3241")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-p3241",
            status: "attached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-p3241",
            status: "detached",
            boot: false,
            server: nil
          )
        )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-p3241/detach")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-p3241",
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
            status: "attached",
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

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-3422f/detach")
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

      expect(stderr).to match("Detaching vol-3422f\n")

      aggregate_failures do
        expect(stdout).to match("vol-p3241")
        expect(stdout).to match("detached")
        expect(stdout).to match("false")
      end
    end
  end
end
