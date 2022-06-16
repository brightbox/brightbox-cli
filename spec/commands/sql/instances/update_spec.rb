require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe "brightbox sql instances" do
  describe "update" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      cache_access_token(config, "44320b29286077c44f14c4efdfed70f63f4a8361")
    end

    context "--maintenance-weekday=Monday" do
      let(:argv) { %w(sql instances update --maintenance-weekday=Monday dbs-12345) }
      let(:expected_args) { { :maintenance_weekday => "1" } }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","maintenance_weekday":0, "maintenance_hour":6}')
          .to_return(:status => 200,
                     :body => '{
                       "id":"dbs-12345",
                       "maintenance_weekday":1,
                       "maintenance_hour":6}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .with(:body => "{\"maintenance_weekday\":\"1\"}")
      end

      it "sets custom maintenance window settings" do
        expect(stderr).to eql("Updating dbs-12345\n")
        expect(stdout).to include("dbs-12345")
      end
    end

    context "--snapshots-schedule='0 12 * * 4'" do
      let(:dbs) { Brightbox::DatabaseServer.find("dbs-12345") }
      let(:argv) { ["sql", "instances", "update", "--snapshots-schedule=0 12 * * 4", "dbs-12345"] }
      let(:expected_args) { { :snapshots_schedule => "0 12 * * 4" } }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":null,"snapshots_schedule_next_at":null}')
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":"34 12 * * 4","snapshots_schedule_next_at":"2016-07-07T12:34:56Z"}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":"34 12 * * 4","snapshots_schedule_next_at":"2016-07-07T12:34:56Z"}')
      end

      it "sets snapshots schedule" do
        expect(Brightbox::DatabaseServer).to receive(:find).and_return(dbs)
        expect(dbs).to receive(:update).with(expected_args).and_call_original

        expect(stderr).to eq("Updating dbs-12345\n")
        expect(stdout).to include("dbs-12345")
      end
    end

    context "--remove-snapshots-schedule" do
      let(:dbs) { Brightbox::DatabaseServer.find("dbs-12345") }
      let(:argv) { %w(sql instances update --remove-snapshots-schedule dbs-12345) }
      let(:expected_args) { { :snapshots_schedule => nil } }

      before do
        stub_request(:get, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":"34 12 * * 4","snapshots_schedule_next_at":"2016-07-07T12:34:56Z"}')
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":null,"snapshots_schedule_next_at":null}')

        stub_request(:put, "http://api.brightbox.localhost/1.0/database_servers/dbs-12345?account_id=acc-12345")
          .to_return(:status => 200, :body => '{"id":"dbs-12345","snapshots_schedule":null,"snapshots_schedule_next_at":null}')
      end

      it "clears snapshots schedule" do
        expect(Brightbox::DatabaseServer).to receive(:find).and_return(dbs)
        expect(dbs).to receive(:update).with(expected_args).and_call_original

        expect(stderr).to eq("Updating dbs-12345\n")
        expect(stdout).to include("dbs-12345")
      end
    end
  end
end
