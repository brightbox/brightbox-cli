require "spec_helper"

describe "brightbox volumes resize" do
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
    let(:argv) { %w[volumes resize] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify the volume ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "without size option" do
    let(:argv) { %w[volumes resize vol-i89u9] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: A 'size' option is required\n")

      expect(stdout).to match("")
    end
  end

  context "with size option" do
    let(:argv) { %w[volumes resize --size 20480 vol-op324] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/volumes/vol-op324")
      .with(query: hash_including(account_id: "acc-12345"))
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-op324",
          size: 10_240
        )
      )
      .to_return(
        status: 200,
        body: volume_response(
          id: "vol-op324",
          size: 20_480
        )
      )

      stub_request(:post, "http://api.brightbox.localhost/1.0/volumes/vol-op324/resize")
        .with(query: hash_including(account_id: "acc-12345"),
              body: hash_including(
                from: 10_240,
                to: 20_480
              ))
        .to_return(
          status: 202,
          body: volume_response(
            id: "vol-op324",
            size: 20_480
          )
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Resizing vol-op324\n")

      aggregate_failures do
        expect(stdout).to match("vol-op324")
        expect(stdout).to match("20480")
      end
    end
  end
end
