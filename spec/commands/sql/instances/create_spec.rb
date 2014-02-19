require "spec_helper"

describe "brightbox database-servers" do
  describe "create" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "without arguments", :vcr do
      let(:argv) { %w{sql instances create } }
      let(:expected_password) { "477wwwj48yifrnuk" }

      it "reports the new admin username" do
        expect(stdout).to include("admin_username: admin")
      end

      it "reports the new admin password" do
        expect(stdout).to include("admin_password: #{expected_password}")
      end
    end

    context "--allow-access=10.0.0.0", :vcr do
      let(:argv) { %w{sql instances create --allow-access=10.0.0.0} }
      let(:expected_args) { { :allow_access => ["10.0.0.0"] } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--allow-access=srv-12345,grp-12345", :vcr do
      let(:argv) { %w{sql instances create --allow-access srv-12345,grp-12345} }
      let(:expected_args) { { :allow_access => %w{srv-12345 grp-12345} } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--engine=mysql", :vcr do
      let(:argv) { %w(sql instances create --engine=mysql) }
      let(:expected_args) { { :database_engine => "mysql" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--engine=mysql --engine-version=5.6", :vcr do
      let(:argv) { %w(sql instances create --engine=mysql --engine-version=5.6) }
      let(:expected_args) { { :database_engine => "mysql", :database_version => "5.6" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--maintenance-weekday=5 --maintenance_hour=11", :vcr do
      let(:argv) { %w(sql instances create --maintenance-weekday=5 --maintenance-hour=11) }
      let(:expected_args) { { :maintenance_weekday => "5", :maintenance_hour => "11" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end

    context "--maintenance-weekday=thursday", :vcr do
      let(:argv) { %w(sql instances create --maintenance-weekday=thursday) }
      let(:expected_args) { { :maintenance_weekday => "4" } }

      it "correctly sends API parameters" do
        expect(Brightbox::DatabaseServer).to receive(:create).with(expected_args).and_call_original
        expect(stderr).to eql("")
      end
    end
  end
end
