require "spec_helper"

describe Brightbox::BBConfig do
  let(:config) { config_from_contents(contents) }
  let(:fog_config) { config.to_fog }

  describe "#to_fog" do
    context "when not configured" do
      let(:contents) { "" }

      it "raises an error" do
        expect {
          fog_config
        }.to raise_error(Brightbox::BBConfigError)
      end
    end

    context "when configured with API client" do
      let(:contents) { API_CLIENT_CONFIG_CONTENTS }

      it "doesn't includes the password" do
        expect(fog_config).to_not have_key(:brightbox_password)
      end
    end

    context "when configured with a User app" do
      let(:contents) { USER_APP_CONFIG_CONTENTS }

      it "includes the password" do
        skip "context is wrong to pass require values through"
        expect(fog_config).to have_key(:brightbox_password)
      end
    end
  end
end
