require "spec_helper"

describe "brightbox volumes copy" do
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
    let(:argv) { %w[volumes copy] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("ERROR: You must specify the volume ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "with argument" do
    let(:argv) { %w[volumes copy vol-909ds] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-909ds")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-909ds"
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-909ds"
        )
      )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-909ds/copy")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-909ds"
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("Copying vol-909ds\n")

      expect(stdout).to match("vol-909ds")
    end
  end
end
