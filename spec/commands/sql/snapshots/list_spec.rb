require "spec_helper"

describe "brightbox database-snapshots" do
  describe "list" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    before do
      config = config_from_contents(USER_APP_CONFIG_CONTENTS)

      # Setup in the VCR recordings
      cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
    end

    context "when resources are available", :vcr do
      let(:argv) { %w(sql snapshots list) }

      it "does not output to stderr" do
        expect(stderr).to be_empty
      end

      it "outputs table details to stdout" do
        expect(stdout).to_not be_empty
        expect(stdout).to match(/dbi-\d+/)
      end
    end
  end
end
