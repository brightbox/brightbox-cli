require "spec_helper"

describe "brightbox sql instances" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "1234567890")
    end

    context "when id does not exist" do
      let(:argv) { %w[sql instances show dbs-12345] }
      let(:json_response) do
        "{\"error_name\":\"missing_resource\",\"errors\":[\"Resource not found using supplied identifier\"]}"
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 404, :body => json_response, :headers => { "Content-Type" => "" })
      end

      it "reports error" do
        expect(stderr).to include("ERROR: Couldn't find an SQL instance with ID dbs-12345")
        expect(stdout).to be_empty
      end
    end

    context "when id exists" do
      let(:argv) { %w[sql instances show dbs-12345] }

      let(:json_response) do
        <<-EOS
        {
          "id":"dbs-12345",
          "resource_type":"database_server",
          "url":"https://api.gb1.brightbox.com/1.0/database_servers/dbs-12345",
          "name":"",
          "description":"",
          "admin_username":"admin",
          "admin_password":null,
          "allow_access":[],
          "database_engine":"mysql",
          "database_version":"5.5",
          "status":"active",
          "maintenance_weekday":0,
          "maintenance_hour":6,
          "snapshots_schedule":"0 16 * * 0",
          "snapshots_schedule_next_at":"2016-07-10T16:00:00Z",
          "created_at":"2016-07-07T12:34:56Z",
          "updated_at":"2016-07-07T12:34:56Z",
          "deleted_at":null,
          "account":{},
          "database_server_type":{},
          "cloud_ips":[],
          "zone":{}
        }
        EOS
      end

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => json_response, :headers => { "Content-Type" => "" })
      end

      it "simplifies the maintenance window" do
        expect(stdout).to include("maintenance_window: Sunday 06:00 UTC")
        expect(stderr).to be_empty
      end

      it "includes snapshots schedule fields" do
        expect(stdout).to include("snapshots_schedule: 0 16 * * 0")
        expect(stdout).to include("snapshots_schedule_next_at: 2016-07-10T16:00Z")
      end
    end
  end
end
