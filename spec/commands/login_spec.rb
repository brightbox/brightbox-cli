require "spec_helper"

describe "brightbox login" do
  let(:output) { FauxIO.new { Brightbox.run(argv) } }
  let(:stdout) { output.stdout }
  let(:stderr) { output.stderr }

  let(:email) { "jason.null@brightbox.com" }
  let(:password) { "N:B3e%7Cmh" }
  let(:client_id) { "app-12345" }
  let(:secret) { "mocbuipbiaa6k6c" }
  let(:api_url) { "http://api.brightbox.dev" }

  let(:default_account) { "acc-12345" }
  let(:client_alias) { email }

  context "when no arguments are given" do
    let(:argv) { %w(login) }

    it "errors prompting for the email address" do
      remove_config
      expect(stderr).to include("You must specify your user's email address")
    end
  end

  context "when no config is present", vcr: true do
    let(:argv) { ["login", "-p", password, email] }

    before do
      remove_config
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
      expect(@client_section["alias"]).to eql(client_alias)
      expect(@client_section["client_id"]).to eql(client_id)
      expect(@client_section["secret"]).to eql(secret)
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

  context "when no password is given", vcr: true do
    let(:argv) { ["login", email] }

    before do
      remove_config
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
      expect(@client_section["alias"]).to eql(client_alias)
      expect(@client_section["client_id"]).to eql(client_id)
      expect(@client_section["secret"]).to eql(secret)
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
