require "spec_helper"

describe "brightbox sql instances" do
  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)

      # Setup in the VCR recordings
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "without arguments", vcr: true do
      let(:argv) { %w(sql instances create) }
      let(:expected_password) { "477wwwj48yifrnuk" }

      it "reports the new admin username" do
        expect(stdout).to include("admin_username: admin")
      end

      it "reports the new admin password" do
        expect(stdout).to include("admin_password: #{expected_password}")
      end
    end

    context "--allow-access=10.0.0.0", vcr: true do
      let(:argv) { %w(sql instances create --allow-access=10.0.0.0) }
      let(:expected_args) { { :allow_access => ["10.0.0.0"] } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--allow-access=srv-12345,grp-12345", vcr: true do
      let(:argv) { %w(sql instances create --allow-access srv-12345,grp-12345) }
      let(:expected_args) { { :allow_access => %w(srv-12345 grp-12345) } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--engine=mysql", vcr: true do
      let(:argv) { %w(sql instances create --engine=mysql) }
      let(:expected_args) { { :database_engine => "mysql" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--engine=mysql --engine-version=5.6", vcr: true do
      let(:argv) { %w(sql instances create --engine=mysql --engine-version=5.6) }
      let(:expected_args) { { :database_engine => "mysql", :database_version => "5.6" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--maintenance-weekday=5 --maintenance_hour=11" do
      let(:argv) { %w(sql instances create --maintenance-weekday=5 --maintenance-hour=11) }
      let(:expected_args) { { :maintenance_weekday => "5", :maintenance_hour => "11" } }

      before do
        stub_request(:post, "http://api.brightbox.dev/token").to_return(
          :status => 200,
          :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}')

        stub_request(:post, "http://api.brightbox.dev/1.0/database_servers?account_id=acc-12345")
          .with(:body => "{\"name\":null,\"description\":null,\"maintenance_weekday\":\"5\",\"maintenance_hour\":\"11\"}")
      end

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--maintenance-weekday=thursday" do
      let(:argv) { %w(sql instances create --maintenance-weekday=thursday) }
      let(:expected_args) { { :maintenance_weekday => "4" } }

      before do
        stub_request(:post, "http://api.brightbox.dev/token").to_return(
          :status => 200,
          :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}')

        stub_request(:post, "http://api.brightbox.dev/1.0/database_servers?account_id=acc-12345")
          .with(:body => "{\"name\":null,\"description\":null,\"maintenance_weekday\":\"4\",\"maintenance_hour\":null}")
      end

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--snapshot=dbi-1493j" do
      let(:argv) { ["sql", "instances", "create", "--snapshot=dbi-1493j"] }
      let(:expected_args) { { :snapshot_id => "dbi-1493j" } }

      let(:json_response) do
        <<-EOS
        {
          "id":"dbs-12345"
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.dev/1.0/database_servers?account_id=acc-12345")
          .with(:headers => { "Content-Type" => "application/json" },
                :body => hash_including("snapshot" => "dbi-1493j"))
          .and_return(:status => 202, :body => json_response)
      end

      it "includes schedule fields in response" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stdout).to include("id: dbs-12345")
        expect(stderr).to eql("")
      end
    end

    context "--snapshots-schedule='0 12 * * 4'" do
      let(:argv) { ["sql", "instances", "create", "--snapshots-schedule=0 12 * * 4"] }
      let(:expected_args) { { :snapshots_schedule => "0 12 * * 4" } }

      let(:json_response) do
        <<-EOS
        {
          "id":"dbs-12345",
          "snapshots_schedule":"0 12 * * 4",
          "snapshots_schedule_next_at":"2016-07-07T12:00:00Z"
        }
        EOS
      end

      before do
        stub_request(:post, "http://api.brightbox.dev/1.0/database_servers?account_id=acc-12345")
          .and_return(:status => 202, :body => json_response)
      end

      it "includes schedule fields in response" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stdout).to include("snapshots_schedule: 0 12 * * 4")
        expect(stdout).to include("snapshots_schedule_next_at: 2016-07-07T12:00Z")
        expect(stderr).to eql("")
      end
    end
  end
end
