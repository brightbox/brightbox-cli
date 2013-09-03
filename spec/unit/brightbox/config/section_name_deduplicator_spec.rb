require "spec_helper"

describe Brightbox::Config::SectionNameDeduplicator do
  subject(:deduper) { Brightbox::Config::SectionNameDeduplicator.new(name, in_use) }

  describe "#next" do
    context "when name is not taken" do
      let(:name) { "app-12345" }
      let(:in_use) { [] }

      it "returns name" do
        expect(deduper.next).to eql("app-12345")
      end
    end

    context "when application ID already exists" do
      let(:name) { "app-12345" }
      let(:in_use) { [name] }

      it "returns a deduplicated name" do
        expect(deduper.next).to eql("app-12345_1")
      end
    end

    context "when alias already exists" do
      let(:name) { "test" }
      let(:in_use) { [name] }

      it "returns a deduplicated name" do
        expect(deduper.next).to eql("test_1")
      end
    end

    context "when name has been deduped before" do
      let(:name) { "dev" }
      let(:in_use) { ["dev", "dev_1", "dev_2"] }

      it "returns a deduplicated name" do
        expect(deduper.next).to eql("dev_3")
      end
    end

    context "when alias has a numerical suffix already" do
      let(:name) { "app_1984" }
      let(:in_use) { ["app_1984"] }

      it "returns a deduplicated name" do
        expect(deduper.next).to eql("app_1985")
      end
    end
  end
end
