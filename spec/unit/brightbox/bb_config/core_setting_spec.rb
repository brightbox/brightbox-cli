require "spec_helper"

describe Brightbox::BBConfig do
  let(:config) { config_from_contents(contents) }

  describe "#core_setting" do
    context "when setting exists" do
      let(:contents) do
        <<-EOS
      [core]
      setting = core value
      [client]
      setting = client setting
        EOS
      end

      it "returns the value from the core setting" do
        expect(config.core_setting("setting")).to eql("core value")
      end
    end

    context "when setting does not exist" do
      let(:contents) { "" }

      it "returns nil" do
        expect(config.core_setting("fnord")).to be_nil
      end
    end
  end
end
