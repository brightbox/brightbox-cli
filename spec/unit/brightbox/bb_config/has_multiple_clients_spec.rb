require "spec_helper"

describe Brightbox::BBConfig do
  let(:config) { config_from_contents(contents) }

  describe "#has_multiple_clients?" do
    context "when config has multiple clients" do
      let(:contents) do
        <<-EOS
        [core]
        default_account = cli-12345

        [cli-12345]
        client_id = cli-12345

        [app-12345]
        client_id = app-12345
        EOS
      end
      it "is true" do
        expect(config.has_multiple_clients?).to be true
      end
    end

    context "when config does not have multiple clients" do
      let(:contents) do
        <<-EOS
        [core]
        default_account = cli-12345

        [cli-12345]
        client_id = cli-12345
        EOS
      end
      it "is false" do
        expect(config.has_multiple_clients?).to be false
      end
    end
  end
end
