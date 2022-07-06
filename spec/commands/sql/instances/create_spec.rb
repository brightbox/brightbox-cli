require "spec_helper"

describe "brightbox sql instances" do
  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    let(:sql_instance) { Brightbox::DatabaseServer.get(new_id) }
    let(:new_id) { stdout.match(/id: (.*?)\n/)[1] }

    before do
      config_from_contents(API_CLIENT_CONFIG_CONTENTS)
      Brightbox.config.reauthenticate
    end

    after do
      sql_instance.wait_for { ready? }
      sql_instance.destroy
    end

    context "without arguments", vcr: true do
      let(:argv) { %w[sql instances create] }

      it "reports the new admin username" do
        username = sql_instance.admin_username
        expect(stdout).to include("admin_username: #{username}")
      end

      it "reports the new admin password" do
        expected_password = sql_instance.admin_password
        expect(stdout).to include("admin_password:")
      end
    end

    context "--allow-access=10.0.0.0", vcr: true do
      let(:argv) { %w[sql instances create --allow-access=10.0.0.0] }
      let(:expected_args) { { :allow_access => ["10.0.0.0"] } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
      end
    end

    context "--allow-access=srv-12345,grp-12345", vcr: true do
      let(:argv) { ["sql", "instances", "create", "--allow-access", "#{server.id},#{group.id}"] }
      let(:expected_args) { { :allow_access => [server.id, group.id] } }
      let(:group) { Brightbox::ServerGroup.all.first }
      let(:server) { Brightbox::Server.create flavor_id: "2gb.nbs", image_id: "img-linux" }

      before do
        server.fog_model.wait_for { ready? }
      end

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
      end

      after do
        server.destroy
      end
    end

    context "--engine=mysql", vcr: true do
      let(:argv) { %w[sql instances create --engine=mysql] }
      let(:expected_args) { { :database_engine => "mysql" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
        expect(stdout).to include("version: 8.0")
      end
    end

    context "--engine=mysql --engine-version=8.0", vcr: true do
      let(:argv) { %w[sql instances create --engine=mysql --engine-version=8.0] }
      let(:expected_args) { { :database_engine => "mysql", :database_version => "8.0" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
        expect(stdout).to include("version: 8.0")
      end
    end

    context "--maintenance-weekday=5 --maintenance_hour=11", vcr: true do
      let(:argv) { %w[sql instances create --maintenance-weekday=5 --maintenance-hour=11] }
      let(:expected_args) { { :maintenance_weekday => "5", :maintenance_hour => "11" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
      end
    end

    context "--maintenance-weekday=thursday", vcr: true do
      let(:argv) { %w[sql instances create --maintenance-weekday=thursday] }
      let(:expected_args) { { :maintenance_weekday => "4" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eq("")
      end
    end

    context "--snapshot=dbi-12345", vcr: true do
      let(:argv) { ["sql", "instances", "create", "--snapshot=#{sql_snapshot.id}"] }
      let(:expected_args) { { :snapshot_id => sql_snapshot.id } }
      let(:source) { Brightbox::DatabaseServer.create({}) }
      let(:sql_snapshot) { source.snapshot(true) }

      before do
        source.fog_model.wait_for { ready? }
        sql_snapshot.wait_for { ready? }
      end

      after do
        source.destroy
        sql_snapshot.destroy
      end

      it "includes schedule fields in response" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stdout).to include("id: #{sql_instance.id}")
        expect(stderr).to eq("")
      end
    end

    context "--snapshots-schedule='0 12 * * 4'", vcr: true do
      let(:argv) { ["sql", "instances", "create", "--snapshots-schedule=0 12 * * 4"] }
      let(:expected_args) { { :snapshots_schedule => "0 12 * * 4" } }

      it "includes schedule fields in response" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stdout).to include("snapshots_schedule: 0 12 * * 4")
        expect(stdout).to match(/snapshots_schedule_next_at: 20\d{2}-\d{2}-\d{2}T12:\d{2}Z/)
        expect(stderr).to eq("")
      end
    end
  end
end
