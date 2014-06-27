require "spec_helper"

describe "brightbox cloudips" do

  describe "map" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)

      # Setup in the VCR recordings
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "when destination is a server ID", :vcr do
      let(:argv) { %w(cloudips map cip-12345 srv-12345) }
      let(:target) { "int-12345" }

      it "passes the interface identifier to the API" do
        expect_any_instance_of(Brightbox::CloudIP).to receive(:map).with(target).and_call_original
        expect(stdout).to include("mapped")
      end
    end

    context "when destination is another value", :vcr do
      let(:target) { "res-12345" }
      let(:argv) { %w(cloudips map cip-12345 res-12345) }

      it "passes the identifier to the API" do
        expect_any_instance_of(Brightbox::CloudIP).to receive(:map).with(target)
        expect(stderr).to include(target)
      end
    end
  end
end
