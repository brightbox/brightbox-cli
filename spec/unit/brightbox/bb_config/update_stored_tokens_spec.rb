require "spec_helper"

describe Brightbox::BBConfig do
  let(:old_access_token) { random_token }
  let(:old_refresh_token) { random_token }

  let(:new_access_token) { random_token }
  let(:new_refresh_token) { random_token }

  let(:config) { config_from_contents(contents) }

  describe "#update_stored_tokens" do
    context "when both tokens have changed" do
      let(:contents) do
        <<-EOS
        [app-12345]
        EOS
      end

      before do
        config.update_stored_tokens(new_access_token, new_refresh_token)
      end

      it "updates access_token" do
        expect(config.access_token).to eql(new_access_token)
      end

      it "has updated the cached access token on disk" do
        expect(cached_access_token(config)).to eql(new_access_token)
      end

      it "updates refresh_token" do
        expect(config.refresh_token).to eql(new_refresh_token)
      end

      it "has updated the cached refresh token on disk" do
        expect(cached_refresh_token(config)).to eql(new_refresh_token)
      end
    end

    context "when only access token has changed" do
      let(:contents) do
        <<-EOS
        [app-12345]
        EOS
      end

      before do
        cache_refresh_token(config, old_refresh_token)
        config.update_stored_tokens(new_access_token)
      end

      it "updates access_token" do
        expect(config.access_token).to eql(new_access_token)
      end

      it "has updated the config file on disk" do
        expect(cached_access_token(config)).to eql(new_access_token)
      end

      it "has not updated the cached refresh token on disk" do
        expect(cached_refresh_token(config)).to eql(old_refresh_token)
      end
    end
  end
end
