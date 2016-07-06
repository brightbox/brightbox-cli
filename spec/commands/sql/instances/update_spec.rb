require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe "brightbox sql instances" do
  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config_from_contents(USER_APP_CONFIG_CONTENTS)
    end

    context "--maintenance-weekday=Monday" do
#      let(:sql_instance) { double }
      let(:argv) { %w(sql instances update --maintenance-weekday=Monday dbs-12345) }
      let(:expected_args) { { :maintenance_weekday => "1" } }

      before do
        stub_request(:post, "http://api.brightbox.dev/token").to_return(
          :status => 200,
          :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}')

        stub_request(:get, "http://api.brightbox.dev/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","maintenance_weekday":0, "maintenance_hour":6}')
          .to_return(:status => 200,
                     :body => '{
                       "id":"dbs-12345",
                       "created_at":"2016-06-20T12:34:56Z",
                       "allow_access":[],
                       "cloud_ips":[],
                       "maintenance_weekday":1,
                       "maintenance_hour":6}')

        stub_request(:put, "http://api.brightbox.dev/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .with(:body => "{\"maintenance_weekday\":\"1\"}")
      end

      it "sets custom maintenance window settings" do
        expect(stderr).to eql("Updating dbs-12345\n")
        expect(stdout).to include("dbs-12345")
      end
    end
  end
end
