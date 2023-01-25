require "spec_helper"

describe "brightbox sql instances resize" do
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
    let(:argv) { %w[sql instances resize] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: You must specify a valid SQL instance ID as the first argument\n")

      expect(stdout).to match("")
    end
  end

  context "with invalid ID" do
    let(:argv) { %w[sql instances resize --type dbt-12345 dbs-xsd23] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-xsd23")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 404,
          body: ""
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: Couldn't find 'dbs-xsd23'\n")

      expect(stdout).to match("")
    end
  end

  context "with valid ID and invalid 'type'" do
    let(:argv) { %w[sql instances resize --type embiggen dbs-e23ss] }

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("ERROR: Cloud SQL type format is invalid\n")

      expect(stdout).to match("")
    end
  end

  context "with valid ID and 'type'" do
    let(:argv) { %w[sql instances resize --type dbt-abcde dbs-zzasa] }

    before do
      stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-zzasa")
        .with(query: hash_including(account_id: "acc-12345"))
        .to_return(
          status: 200,
          body: {
            id: "dbs-zzasa",
            database_type: "dbt-12345"
          }.to_json
        )
        .to_return(
          status: 200,
          body: {
            id: "dbs-zzasa",
            database_type: "dbt-abcde"
          }.to_json
        )

      stub_request(:post, "http://api.brightbox.localhost/1.0/database_servers/dbs-zzasa/resize")
        .with(query: hash_including(account_id: "acc-12345"),
              body: {
                new_type: "dbt-abcde"
              }
        )
        .to_return(
          status: 202,
          body: {
            id: "dbs-zzasa",
            database_type: "dbt-abcde"
          }.to_json
        )
    end

    it "does not error" do
      expect { output }.to_not raise_error

      expect(stderr).to eq("Resizing dbs-zzasa\n")

      expect(stdout).to match("dbs-zzasa")
    end
  end
end
