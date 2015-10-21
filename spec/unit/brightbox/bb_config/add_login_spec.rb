require "spec_helper"

describe Brightbox::BBConfig, "#add_login" do
  let(:config) { Brightbox::BBConfig.new }

  let(:email) { "jason.null@brightbox.com" }
  let(:password) { "N:B3e%7Cmh" }
  let(:api_url) { ENV["BRIGHTBOX_API_URL"] || "http://api.brightbox.dev" }

  context "when no config exists", vcr: true do
    let(:expected_config) do
      <<EOS
[core]
default_client = #{email}

[#{email}]
username = #{email}
api_url = #{api_url}
auth_url = #{api_url}
default_account = acc-12345

EOS
    end

    before do
      remove_config
    end

    it "creates the configuration" do
      FauxIO.new do
        config.add_login(email, password)
      end
      expect(config_file_contents).to eq(expected_config)
    end

    it "refreshed tokens" do
      FauxIO.new do
        expect { config.add_login(email, password) }.not_to raise_error
      end

      expect(cached_access_token(config)).to eq(config.access_token)
      expect(cached_refresh_token(config)).to eq(config.refresh_token)
    end
  end

  context "when logged in previously", vcr: true do
    let(:original_config) { config_file_contents }

    before do
      FauxIO.new { config.add_login(email, password) }
    end

    it "does not alter the configuration" do
      FauxIO.new do
        expect {
          config.add_login(email, password)
        }.not_to change { config_file_contents }.from(original_config)
      end
    end

    it "updates access token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.access_token
        }.from(cached_access_token(config))
      end
    end

    it "updates refresh token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.refresh_token
        }.from(cached_refresh_token(config))
      end
    end
  end

  context "when configured with custom options", vcr: true do
    let(:original_config) { config_file_contents }

    let(:custom_url) { ENV["BRIGHTBOX_API_URL"] || "http://api.brightbox.dev" }
    let(:custom_app_id) { "app-23456" }
    let(:custom_app_secret) { "ho04hondtzjjdf4" }
    let(:custom_default_account) { "acc-23456" }

    let(:custom_options) do
      {
        api_url: custom_url,
        auth_url: custom_url,
        default_account: custom_default_account,
        client_id: custom_app_id,
        secret: custom_app_secret
      }
    end

    before do
      FauxIO.new { config.add_login(email, password, custom_options) }
    end

    it "does not alter the configuration" do
      FauxIO.new do
        expect {
          config.add_login(email, password)
        }.not_to change { config_file_contents }.from(original_config)
      end

      expect(config_file_contents).to match("[#{email}]")
      expect(config_file_contents).to match("api_url = #{custom_url}")
      expect(config_file_contents).to match("auth_url = #{custom_url}")
      expect(config_file_contents).to match("username = #{email}")
      expect(config_file_contents).to match("default_account = #{custom_default_account}")
      expect(config_file_contents).to match("default_client = #{email}")
    end

    it "updates access token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.access_token
        }.from(cached_access_token(config))
      end
    end

    it "updates refresh token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.refresh_token
        }.from(cached_refresh_token(config))
      end
    end
  end

  context "when altering a custom option", vcr: true do
    let(:original_config) { config_file_contents }

    let(:custom_url) { ENV["BRIGHTBOX_API_URL"] || "http://api.brightbox.dev" }
    let(:custom_app_id) { "app-23456" }
    let(:custom_app_secret) { "ho04hondtzjjdf4" }
    let(:custom_default_account) { "acc-23456" }

    let(:custom_options) do
      {
        api_url: custom_url,
        auth_url: custom_url,
        default_account: custom_default_account,
        client_id: custom_app_id,
        secret: custom_app_secret
      }
    end

    before do
      FauxIO.new { config.add_login(email, password, custom_options) }
    end

    it "does not alter the configuration" do
      FauxIO.new do
        expect {
          config.add_login(email, password)
        }.not_to change { config_file_contents }.from(original_config)
      end

      expect(config_file_contents).to match("[#{email}]")
      expect(config_file_contents).to match("api_url = #{custom_url}")
      expect(config_file_contents).to match("username = #{email}")
      expect(config_file_contents).to match("default_account = #{custom_default_account}")
      expect(config_file_contents).to match("default_client = #{email}")
    end

    it "updates access token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.access_token
        }.from(cached_access_token(config))
      end
    end

    it "updates refresh token" do
      FauxIO.new do
        expect { config.add_login(email, password) }.to change {
          config.refresh_token
        }.from(cached_refresh_token(config))
      end
    end
  end

  context "when using an email and suffix", vcr: true do
    let(:client_name) { "#{email}/dev" }
    let(:expected_config) do
      <<EOS
[core]
default_client = #{client_name}

[#{client_name}]
username = #{email}
api_url = #{api_url}
auth_url = #{api_url}
default_account = acc-12345

EOS
    end

    before do
      remove_config
    end

    it "creates the configuration" do
      FauxIO.new do
        config.add_login(client_name, password)
      end
      expect(config_file_contents).to eq(expected_config)
    end

    it "refreshed tokens" do
      FauxIO.new do
        expect { config.add_login(email, password) }.not_to raise_error
      end

      expect(cached_access_token(config)).to eq(config.access_token)
      expect(cached_refresh_token(config)).to eq(config.refresh_token)
    end
  end

end
