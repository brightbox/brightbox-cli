require "spec_helper"

describe Brightbox::BBConfig do
  let(:api_endpoint) { "http://api.brightbox.dev" }

  # These are fake values that dev servers may choose to allow
  let(:username) { "jason.null@brightbox.com" }
  let(:password) { "N:B3e%7Cmh" } # Jason's cat's name
  let(:app_id) { "app-12345" }
  let(:app_secret) { "mocbuipbiaa6k6c" }
  let(:cli_id) { "cli-12345" }
  let(:cli_secret) { "qy6xxnvy4o0tgv5" }

  describe "#renew_tokens" do
    context "when using a user app with no tokens", vcr: true do
      before do
        contents = <<-EOS
        [core]
        default_client = app-12345

        [app-12345]
        api_url = #{api_endpoint}
        client_id = #{app_id}
        secret = #{app_secret}
        username = #{username}
        EOS

        # Hardcoded in VCR recording
        @new_access_token = "a57331b172474165888d7d76a8579720971a4c89"
        @new_refresh_token = "eb6424e92b053256ea0a9ec477df34d86353b41a"

        @config = config_from_contents(contents)
        expect(@config).to receive(:prompt_for_password).and_return(password)
        @output = FauxIO.new { @config.renew_tokens }
      end

      it "caches the new tokens" do
        # Access token
        expect(File.exist?(@config.access_token_filename)).to be true

        expect(cached_access_token(@config)).to eql(@new_access_token)

        # Refresh token
        expect(cached_refresh_token(@config)).to eql(@new_refresh_token)
      end

    end

    context "when using a user app with a cached refresh token", vcr: true do
      before do
        @config = config_from_contents(USER_APP_CONFIG_CONTENTS)

        @old_refresh_token = "aeed54b3487019931b04010b0b39715eb4e729e8"
        cache_refresh_token(@config, @old_refresh_token)
        expect(@config.refresh_token).to eql(@old_refresh_token)

        # This are fudged in the VCR recording
        @new_access_token = "0d09cf23393aeb039b7abe6fd15339108095e927"
        @new_refresh_token = "53779449e94964eefb10daaa4807fd5f007b5211"

        # If we are prompting then the refresh token has failed
        expect(@config).to_not receive(:prompt_for_password)
        @output = FauxIO.new { @config.renew_tokens }
      end

      it "caches the new tokens" do
        # Access token
        expect(File.exist?(@config.access_token_filename)).to be true

        # NOTE The cached to disk version is filtered by VCR when testing
        expect(cached_access_token(@config)).to eql(@new_access_token)

        # Refresh token
        expect(cached_refresh_token(@config)).to eql(@new_refresh_token)
      end
    end

    context "when using a user app with an expired refresh token", vcr: true do
      before do
        @config = config_from_contents(USER_APP_CONFIG_CONTENTS)

        @old_refresh_token = "aeed54b3487019931b04010b0b39715eb4e729e8"
        cache_refresh_token(@config, @old_refresh_token)

        expect(@config.refresh_token).to eql(@old_refresh_token)

        @new_access_token = "f0cf301ba7d82e6b6bbd61e3f40929b7fbd55a6b"
        @new_refresh_token = "2d5f189f75c4359131262716a9ad0144877e9f27"

        expect(@config).to receive(:prompt_for_password).and_return(password)
        @output = FauxIO.new { @config.renew_tokens }
      end

      it "caches the new tokens" do
        # Access token
        expect(File.exist?(@config.access_token_filename)).to be true

        # NOTE The cached to disk version is filtered by VCR when testing
        expect(cached_access_token(@config)).to eql(@new_access_token)

        # Refresh token
        expect(cached_refresh_token(@config)).to eql(@new_refresh_token)
      end
    end

    context "when using an API client with no tokens", vcr: true do
      before do
        @new_access_token = random_token
        @config = config_from_contents(API_CLIENT_CONFIG_CONTENTS)

        expect(@config).to_not receive(:prompt_for_password)

        @output = FauxIO.new { @config.renew_tokens }
      end

      it "caches a new access token" do
        expect(File.exist?(@config.access_token_filename)).to be true
        expect(cached_access_token(@config)).to eql("5f3fd8fe25388fc9b801afc15a23d3991c68257d")
      end
    end

    context "when config in use is not the default", vcr: true do
      before do
        contents = <<-EOS
        [core]
        default_client = cli-12345
        [cli-12345]
        api_url = http://example.com
        client_id = #{cli_id}
        secret = #{cli_secret}
        [app-12345]
        api_url = #{Brightbox::DEFAULT_API_ENDPOINT}
        client_id = #{app_id}
        secret = #{app_secret}
        username = #{username}
        EOS

        @config = config_from_contents(contents)
        mock_password_entry
      end

      it "uses correct credentials" do
        @config.client_name = app_id
        expected_options = {
          :brightbox_api_url => Brightbox::DEFAULT_API_ENDPOINT,
          :brightbox_client_id => app_id
        }
        expect(Fog::Compute).to receive(:new).with(hash_including(expected_options)).and_call_original
        @output = FauxIO.new { @config.renew_tokens }
      end
    end
  end
end
