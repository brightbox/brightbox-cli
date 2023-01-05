require "spec_helper"

describe "brightbox volumes attach" do
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
    let(:argv) { %w[volumes attach] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify the volume ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "without server arguments" do
    let(:argv) { %w[volumes attach vol-32145] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify the server ID to attach to as the second argument\n")

      expect(stdout).to match("")
    end
  end

  context "with arguments" do
    let(:argv) { %w[volumes attach vol-809s1 srv-03431] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-809s1")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-809s1",
            status: "detached",
            boot: false,
            server: nil
          )
        )
        .to_return(
          status: 200,
          body: volume_response(
            id: "vol-809s1",
            status: "attached",
            boot: false,
            server: {
              id: "srv-03431"
            }
          )
        )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-809s1/attach")
        .with(query: hash_including(account_id: "acc-12345"),
              body: hash_including(
                server: "srv-03431",
                boot: false
              ))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-809s1",
            status: "attached",
            server: {
              id: "srv-03431"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Attaching vol-809s1\n")

      aggregate_failures do
        expect(stdout).to match("vol-809s1")
        expect(stdout).to match("attached")
        expect(stdout).to match("false")
      end
    end
  end

  context "with boot option" do
    let(:argv) { %w[volumes attach --boot vol-90328 srv-03431] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-90328")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-90328",
          status: "detached",
          boot: false,
          server: nil
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-90328",
          status: "attached",
          boot: true,
          server: {
            id: "srv-03431"
          }
        )
      )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-90328/attach")
        .with(query: hash_including(account_id: "acc-12345"),
              body: hash_including(
                server: "srv-03431",
                boot: true
              ))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-90328",
            boot: true,
            status: "attached",
            server: {
              id: "srv-03431"
            }
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Attaching vol-90328\n")

      aggregate_failures do
        expect(stdout).to match("vol-90328")
        expect(stdout).to match("attached")
        expect(stdout).to match("true")
      end
    end
  end
end
