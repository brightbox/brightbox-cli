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
  end
end
