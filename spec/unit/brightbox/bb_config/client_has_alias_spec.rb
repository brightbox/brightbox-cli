require "spec_helper"

describe Brightbox::BBConfig do
  let(:contents) do
    <<-EOS
    [alias]
    client_id = cli-11111

    [cli-12345]
    client_id = cli-12345

    [cli-54321]
    alias = old_alias
    client_id = cli-54321
    EOS
  end
  let(:config) { config_from_contents(contents) }

  describe "#client_has_alias?" do
    context "when client has old 'alias' key" do
      it "returns true" do
        config.client_name = "old_alias"
        expect(config.client_has_alias?).to be_true
      end
    end

    context "when client has a section header" do
      it "returns true" do
        config.client_name = "alias"
        expect(config.client_has_alias?).to be_true
      end
    end

    context "when client 'alias' is the identifier" do
      it "returns false" do
        config.client_name = "cli-12345"
        expect(config.client_has_alias?).to be_false
      end
    end
  end
end
