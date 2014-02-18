require "spec_helper"

describe "brightbox database-servers" do
  describe "snapshot" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)

      # Setup in the VCR recordings
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "when database server active", :vcr do
      let(:argv) { %w{sql instances snapshot dbs-12345} }
      let(:expected_args) { { :allow_access => ["10.0.0.0"] } }

      it "correctly sends API parameters" do
        expect_any_instance_of(Brightbox::DatabaseServer).to receive(:snapshot).and_call_original
        expect(stderr).to include("Creating snapshot for dbs-12345")
      end
    end

    context "when database server can not be snapshotted", :vcr do
      let(:argv) { %w{sql instances snapshot dbs-12345} }

      it "reports an error to the user" do
        expect_any_instance_of(Brightbox::DatabaseServer).to receive(:snapshot).and_call_original
        expect(stderr).to include("Creating snapshot for dbs-12345")
        expect(stderr).to include("ERROR: Unable to action the request due to conflicting states")
      end
    end
  end
end
