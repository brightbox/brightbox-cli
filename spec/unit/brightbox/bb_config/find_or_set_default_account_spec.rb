require "spec_helper"

describe Brightbox::BBConfig do
  let(:config) { config_from_contents(contents) }

  describe "#find_or_set_default_account" do
    context "when a default account is available" do
      let(:contents) do
        <<-EOS
        [cli-default]
        api_url = http://api.brightbox.dev
        client_id = cli-default
        secret = qy6xxnvy4o0tgv5
        default_account = acc-default
        EOS
      end

      it "does not update" do
        expect {
          config.find_or_set_default_account
        }.to_not change(config, :default_account)
      end
    end

    context "when client is not authenticated", :vcr do
      let(:contents) do
        <<-EOS
        [cli-12345]
        api_url = http://api.brightbox.dev
        client_id = cli-12345
        secret = wrong_password
        EOS
      end

      it "does not raise an error" do
        expect {
          config.find_or_set_default_account
        }.to_not raise_error
      end

      it "does not update " do
        expect {
          config.find_or_set_default_account
        }.to_not change(config, :default_account)
      end
    end

    context "when client may access one account", :vcr do
      let(:contents) do
        <<-EOS
        [cli-12345]
        api_url = http://api.brightbox.dev
        client_id = cli-12345
        secret = qy6xxnvy4o0tgv5
        EOS
      end

      it "updates the setting" do
        expect {
          config.find_or_set_default_account
        }.to change(config, :default_account)
      end
    end

    context "when the client may access multiple accounts", :vcr do
      let(:contents) do
        <<-EOS
        [app-12345]
        api_url = http://api.brightbox.dev
        client_id = app-12345
        secret = mocbuipbiaa6k6c
        EOS
      end

      it "does not update" do
        expect {
          config.find_or_set_default_account
        }.to_not change(config, :default_account)
      end
    end
  end
end
