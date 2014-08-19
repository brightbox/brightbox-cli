require "spec_helper"

describe "brightbox servers" do

  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  let(:resource_class) { Brightbox::Server }
  let(:resource_id) { "srv-12345" }
  let(:resource) { double(resource_class, :to_s => resource_id) }

  let(:resource_ids) { [resource_id] }
  let(:results) { [resource] }

  before do
    config = config_from_contents(USER_APP_CONFIG_CONTENTS)
    cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
  end

  describe "reboot" do
    context "when resource is known" do
      let(:argv) { %w(servers reboot srv-12345) }

      before do
        expect(resource_class).to receive(:find_or_call).with(resource_ids).and_return(results)
        expect(resource).to receive(:reboot).with(false)
      end

      it "outputs notice to STDERR" do
        expect(stderr).to match("Sending reboot to #{resource_id}")
      end
    end

    context "when resource is unknown" do
      let(:argv) { %w(servers reboot srv-12345) }

      before do
        expect(resource_class).to receive(:find).with(resource_id).and_raise(Brightbox::Api::NotFound)
      end

      it "outputs error to STDERR" do
        expect(stderr).to match("ERROR: Couldn't find #{resource_id}")
      end
    end

    context "when no arguments are passed" do
      let(:argv) { %w(servers reboot) }

      it "outputs error to STDERR" do
        expect(stderr).to match("ERROR: You must specify servers to reboot")
      end
    end
  end
end
