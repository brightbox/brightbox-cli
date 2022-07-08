require "spec_helper"

describe "brightbox sql snapshots" do
  describe "show" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)

      # Setup in the VCR recordings
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "when resource exists", vcr: true do
      let(:argv) { %w[sql snapshots show dbi-12345] }

      it "does not output to stderr" do
        expect(stderr).to eql("")
      end

      it "outputs table details to stdout" do
        expect(stdout).to_not be_empty
        expect(stdout).to match(/dbi-12345/)
      end
    end
  end
end
