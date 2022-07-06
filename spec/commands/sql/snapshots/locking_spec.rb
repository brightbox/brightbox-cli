require "spec_helper"

describe "brightbox sql snapshots" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  let(:resource_class) { Brightbox::DatabaseSnapshot }
  let(:resource_id) { "dbi-12345" }
  let(:resource) { double(resource_class, :to_s => resource_id) }

  let(:resource_ids) { [resource_id] }
  let(:results) { [resource] }

  before do
    config = config_from_contents(USER_APP_CONFIG_CONTENTS)
    cache_access_token(config, "f83da712e6299cda953513ec07f7a754f747d727")
  end

  describe "lock" do
    context "when resource is known" do
      let(:argv) { %w[sql snapshots lock dbi-12345] }

      before do
        expect(resource_class).to receive(:find_or_call).with(resource_ids).and_return(results)
        expect(resource).to receive(:lock!)
      end

      it "outputs notice to STDERR" do
        expect(stderr).to match("Locking #{resource_id}")
      end
    end

    context "when resource is unknown" do
      let(:argv) { %w[sql snapshots lock dbi-12345] }

      before do
        expect(resource_class).to receive(:find).with(resource_id).and_raise(Brightbox::Api::NotFound)
      end

      it "outputs error to STDERR" do
        expect(stderr).to match("Couldn't find #{resource_id}")
      end
    end
  end

  describe "unlock" do
    context "when resource is known" do
      let(:argv) { %w[sql snapshots unlock dbi-12345] }

      before do
        expect(resource_class).to receive(:find_or_call).with(resource_ids).and_return(results)
        expect(resource).to receive(:unlock!)
      end

      it "outputs notice to STDERR" do
        expect(stderr).to match("Unlocking #{resource_id}")
      end
    end

    context "when resource is unknown" do
      let(:argv) { %w[sql snapshots unlock dbi-12345] }

      before do
        expect(resource_class).to receive(:find).with(resource_id).and_raise(Brightbox::Api::NotFound)
      end

      it "outputs error to STDERR" do
        expect(stderr).to match("Couldn't find #{resource_id}")
      end
    end
  end
end
