require "spec_helper"

describe "brightbox sql snapshots" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "without arguments" do
      let(:argv) { %w[sql snapshots show] }

      it "reports error" do
        expect(stderr).to include("You must specify snapshot ids to show")
        expect(stdout).to be_empty
      end
    end

    context "with identifier argument" do
      let(:argv) { %w[sql snapshots show dbi-12345] }
      let(:json_response) do
        <<~EOS
        {
          "id": "dbi-12345",
          "resource_type": "database_snapshot",
          "url": "string",
          "name": "string",
          "description": "string",
          "status": "creating",
          "locked": true,
          "database_engine": "string",
          "database_version": "string",
          "source": "string",
          "source_trigger": "manual",
          "size": 0,
          "created_at": "2024-12-17T10:14:38.092Z",
          "updated_at": "2024-12-17T10:14:38.092Z",
          "deleted_at": "2024-12-17T10:14:38.092Z",
          "account": {
            "id": "acc-12345",
            "resource_type": "account",
            "url": "string",
            "name": "string",
            "description": "string",
            "status": "pending"
          },
          "metadata": {
            "labels": {}
          }
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_snapshots/dbi-12345?account_id=acc-12345")
          .to_return(status: 200, body: json_response)
      end

      it "outputs table details to stdout" do
        aggregate_failures do
          expect(stderr).to be_empty unless ENV["DEBUG"]
          expect(stdout).to_not be_empty
          expect(stdout).to match(/dbi-12345/)
        end
      end
    end
  end
end
