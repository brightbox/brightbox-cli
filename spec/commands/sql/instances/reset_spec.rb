require "spec_helper"

describe "brightbox sql instances reset" do
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
    let(:argv) { %w[sql instances reset] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("ERROR: You must specify a valid SQL instance ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "with invalid ID" do
    let(:argv) { %w[sql instances reset dbs-l3kd4] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-l3kd4")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 404,
          body: ""
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("ERROR: Couldn't find 'dbs-l3kd4'\n")

      expect(stdout).to match("")
    end
  end

  context "with valid ID" do
    let(:argv) { %w[sql instances reset dbs-po953] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-po953")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "dbs-po953"
          }.to_json
        )

      stub_request(:post, "http://api.brightbox.localhost/1.0/database_servers/dbs-po953/reset")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 202,
          body: {
            id: "dbs-po953"
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to include("Resetting dbs-po953\n")

      expect(stdout).to match("dbs-po953")
    end
  end
end
