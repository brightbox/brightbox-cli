require "spec_helper"

describe Brightbox::BBConfig do
  describe "#client_id" do
    context "when client has old 'alias' key" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = section

        [section]
        alias = alias
        client_id = cli-12345
        EOS
      end
      let(:config) { config_from_contents(contents) }

      it "returns the identifier" do
        expect(config.client_id).to eql("cli-12345")
      end

      it "doesn't return the section header" do
        expect(config.client_id).to_not eql("section")
      end

      it "doesn't return the alias" do
        expect(config.client_id).to_not eql("alias")
      end
    end
  end
end
