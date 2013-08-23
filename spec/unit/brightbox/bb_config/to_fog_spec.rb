require "spec_helper"
require "tempfile"

describe Brightbox::BBConfig do
  describe "#to_fog" do
    let(:config) { config_from_contents(contents) }
    let(:fog_config) { config.to_fog }

    context "when not configured correctly" do
      let(:contents) { "" }

      it "raises an error" do
        expect {
          fog_config.to_fog
        }.to raise_error(Brightbox::BBConfigError)
      end
    end

    context "when access token is known" do
      let(:contents) { API_CLIENT_CONFIG_CONTENTS }
      let(:access_token) { random_token }

      it "includes the token" do
        config.access_token = access_token
        expect(fog_config[:brightbox_access_token]).to eql(access_token)
      end
    end

    context "when access token is known" do
      let(:contents) { USER_APP_CONFIG_CONTENTS }
      let(:access_token) { random_token }
      let(:refresh_token) { random_token }

      it "includes the token" do
        config.access_token = access_token
        config.refresh_token = refresh_token
        expect(fog_config[:brightbox_refresh_token]).to eql(refresh_token)
      end
    end

    context "when API client config used" do
      let(:contents) { API_CLIENT_CONFIG_CONTENTS }

      it "returns correct fog options" do
        expect(fog_config[:provider]).to eql("Brightbox")
        expect(fog_config[:brightbox_api_url]).to eql("http://api.brightbox.dev")
        expect(fog_config[:brightbox_client_id]).to eql("cli-12345")
        expect(fog_config[:brightbox_secret]).to eql("qy6xxnvy4o0tgv5")
      end
    end

    context "when user app config used" do
      let(:contents) { USER_APP_CONFIG_CONTENTS }

      it "returns correct fog options" do
        expect(fog_config[:provider]).to eql("Brightbox")
        expect(fog_config[:brightbox_api_url]).to eql("http://api.brightbox.dev")
        expect(fog_config[:brightbox_client_id]).to eql("app-12345")
        expect(fog_config[:brightbox_secret]).to eql("mocbuipbiaa6k6c")
      end
    end
  end
end
