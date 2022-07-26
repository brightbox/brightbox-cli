require "spec_helper"

describe "brightbox login" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  let(:email) { "jason.null@brightbox.com" }
  let(:password) { "N:B3e%7Cmh" }
  let(:client_id) { "app-12345" }
  let(:secret) { "mocbuipbiaa6k6c" }
  let(:api_url) { "http://api.brightbox.localhost" }

  let(:default_account) { "acc-12345" }
  let(:client_alias) { email }

  context "when no arguments are given" do
    let(:argv) { %w[login] }

    it "errors prompting for the email address" do
      remove_config
      expect(stderr).to include("You must specify your email address")
    end
  end

  context "when no config is present" do
    let(:argv) { ["login", "-p", password, email] }

    before do
      remove_config
    end

    context "without correct authentication" do
      before do
        stub_request(:post, "#{api_url}/token")
          .with(
            body: {
              grant_type: "password",
              username: email,
              password: password
            }.to_json
          ).to_return(
            status: 401,
            body: { error: "invalid_client" }.to_json
          )
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
        expect(@client_section["username"]).to eql(email)

        expect(@client_section["default_account"]).to be_nil
      end

      it "requests access tokens" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => email

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end
    end

    context "with correct authentication" do
      before do
        stub_token_request
        stub_accounts_request
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
        expect(@client_section["username"]).to eql(email)
        expect(@client_section["default_account"]).to eql(default_account)
      end

      it "requests access tokens" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => email

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end

      it "does not prompt to rerun the command" do
        expect(stderr).to_not include("please re-run your command")
      end
    end
  end

  context "when no password is given" do
    let(:argv) { ["login", email] }

    before do
      remove_config
      stub_token_request
      stub_accounts_request
      mock_password_entry(password)
    end

    it "prompts for the password" do
      expect { output }.not_to raise_error
    end

    it "does not error" do
      expect { output }.to_not raise_error
      expect(stderr).to_not include("ERROR")
    end

    it "sets up the config" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new
      @client_section = @config.config[email]

      expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
      expect(@client_section["username"]).to eql(email)
      expect(@client_section["default_account"]).to eql(default_account)
    end

    it "requests access tokens" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new :client_name => email

      expect(cached_access_token(@config)).to eql(@config.access_token)
      expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
    end

    it "does not prompt to rerun the command" do
      expect(stderr).to_not include("please re-run your command")
    end
  end

  context "when custom api/auth URLs are given" do
    let(:api_url) { Brightbox::DEFAULT_API_ENDPOINT }
    let(:auth_url) { Brightbox::DEFAULT_API_ENDPOINT }
    let(:argv) { ["login", "--api-url", api_url, "--auth-url", auth_url, email] }

    before do
      remove_config
      stub_token_request
      stub_accounts_request
      mock_password_entry(password)
    end

    it "prompts for the password" do
      expect { output }.not_to raise_error
    end

    it "does not error" do
      expect { output }.to_not raise_error
      expect(stderr).to_not include("ERROR")
    end

    it "sets up the config" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new
      @client_section = @config.config[email]

      expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
      expect(@client_section["auth_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
      expect(@client_section["username"]).to eql(email)
      expect(@client_section["default_account"]).to eql(default_account)
    end

    it "requests access tokens" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new :client_name => email

      expect(cached_access_token(@config)).to eql(@config.access_token)
      expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
    end

    it "does not prompt to rerun the command" do
      expect(stderr).to_not include("please re-run your command")
    end
  end

  context "when default account is passed" do
    let(:account) { "acc-23456" }
    let(:argv) { ["login", "--default-account", account, email] }

    before do
      remove_config
      stub_token_request
      mock_password_entry(password)
    end

    it "prompts for the password" do
      expect { output }.not_to raise_error
    end

    it "does not error" do
      expect { output }.to_not raise_error
      expect(stderr).to_not include("ERROR")
    end

    it "sets up the config" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new
      @client_section = @config.config[email]

      expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
      expect(@client_section["auth_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
      expect(@client_section["username"]).to eql(email)
      expect(@client_section["default_account"]).to eql(account)
    end

    it "requests access tokens" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new :client_name => email

      expect(cached_access_token(@config)).to eql(@config.access_token)
      expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
    end

    it "does not prompt to rerun the command" do
      expect(stderr).to_not include("please re-run your command")
    end
  end

  context "when alternative client credentials are given" do
    let(:other_client_identifier) { "app-23456" }
    let(:other_client_secret) { "ho04hondtzjjdf4" }
    let(:argv) { ["login", "--application-id", other_client_identifier, "--application-secret", other_client_secret, email] }

    before do
      remove_config
      stub_token_request
      stub_accounts_request
      mock_password_entry(password)
    end

    it "prompts for the password" do
      expect { output }.not_to raise_error
    end

    it "does not error" do
      expect { output }.to_not raise_error
      expect(stderr).to_not include("ERROR")
    end

    it "sets up the config" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new
      @client_section = @config.config[email]

      expect(@client_section["client_id"]).to eql(other_client_identifier)
      expect(@client_section["secret"]).to eql(other_client_secret)
    end

    it "requests access tokens" do
      expect { output }.to_not raise_error

      @config = Brightbox::BBConfig.new :client_name => email

      expect(cached_access_token(@config)).to eql(@config.access_token)
      expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
    end

    it "does not prompt to rerun the command" do
      expect(stderr).to_not include("please re-run your command")
    end
  end

  context "when login is used to refresh tokens" do
    let(:email) { "jason.null@brightbox.com" }
    let(:client_alias) { "#{email}/custom" }
    let(:custom_api_url) { "https://api.example.com" }
    let(:custom_auth_url) { "https://auth.example.com" }
    let(:default_account) { "acc-custom" }

    let(:contents) do
      <<-EOS
      [core]
      default_client = #{client_alias}

      [#{client_alias}]
      username = #{email}
      api_url = #{custom_api_url}
      auth_url = #{custom_auth_url}
      default_account = #{default_account}
      EOS
    end
    let(:config) { Brightbox::BBConfig.new }

    let(:argv) { ["login", client_alias] }

    before do
      config_from_contents(contents)
      mock_password_entry(password)

      stub_request(:post, "https://auth.example.com/token").to_return(
        :status => 200,
        :body => '{"access_token":"44320b29286077c44f14c4efdfed70f63f4a8361","token_type":"Bearer","refresh_token":"759b2b28c228948a0ba5d07a89f39f9e268a95c0","scope":"infrastructure orbit","expires_in":7200}'
      ).times(2)
    end

    it "does not change the config" do
      expect { output }.to_not raise_error

      client_section = config.config[client_alias]

      expect(client_section["api_url"]).to eql(custom_api_url)
      expect(client_section["auth_url"]).to eql(custom_auth_url)
      expect(client_section["username"]).to eql(email)
      expect(client_section["default_account"]).to eql(default_account)
    end

    it "requests access tokens" do
      expect { output }.to_not raise_error

      expect(cached_access_token(config)).to eql(config.access_token)
      expect(cached_refresh_token(config)).to eql(config.refresh_token)
    end

    it "does not prompt to rerun the command" do
      expect(stderr).to_not include("please re-run your command")
    end
  end

  context "when user has 2FA set up" do
    let(:config) { Brightbox::BBConfig.new client_name: email }

    context "with existing configuration" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = #{client_alias}

        [#{client_alias}]
        username = #{email}
        default_account = #{default_account}
        two_factor = true
        EOS
      end

      context "when no password is given" do
        let(:argv) { ["login", email] }

        before do
          config_from_contents(contents)
          stub_token_request(two_factor: true)
          stub_accounts_request
          mock_password_entry(password)
          mock_otp_entry("123456")
        end

        it "prompts for the password" do
          expect { output }.not_to raise_error
        end

        it "does not error" do
          expect { output }.to_not raise_error
          expect(stderr).to_not include("ERROR")
        end

        it "requests access tokens" do
          expect { output }.to_not raise_error

          expect(cached_access_token(config)).to eql(config.access_token)
          expect(cached_refresh_token(config)).to eql(config.refresh_token)
        end

        it "does not prompt to rerun the command" do
          expect(stderr).to_not include("please re-run your command")
        end
      end
    end
  end
end
