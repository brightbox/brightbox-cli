require "spec_helper"

describe Brightbox::BBConfig do

  describe "#add_section" do
    context "when first and only client", vcr: true do
      let(:config) { Brightbox::BBConfig.new }
      let(:client_alias) { "dev" }
      let(:client_id) { "app-12345" }
      let(:secret) { "mocbuipbiaa6k6c" }
      let(:account_id) { "acc-12345" }
      let(:options) do
        {
          :username => "jason.null@brightbox.com",
          :api_url => "http://api.brightbox.dev"
        }
      end
      let(:saved_config) { config_file_contents }

      before do
        remove_config
        mock_password_entry

        FauxIO.new do
          config.add_section(client_alias, client_id, secret, options)
        end
      end

      it "saves changes to the config file" do
        expect(saved_config).to match("client_id = #{client_id}")
      end

      it "requests tokens for the new client"

      it "saves the default account" do
        expect(saved_config).to match("default_account = #{account_id}")
      end

      it "saves the new client as the default" do
        expect(saved_config).to match("default_client = #{client_alias}")
      end
    end
  end
end
