require "spec_helper"

# Note these specs have to be fudged to be rerecorded. There is no dev client on
# the production system (d'uh!) so the default API endpoint that is added will
# send invalid credentials to the real API and be rejected.
#
describe "brightbox config" do

  describe "user_add" do
    let(:output) { FauxIO.new { Brightbox::run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    let(:email) { "jason.null@brightbox.com" }
    let(:client_id) { "app-12345" }
    let(:secret) { "mocbuipbiaa6k6c" }
    let(:password) { "N:B3e%7Cmh" }
    let(:api_url) { "http://api.brightbox.dev" }

    let(:default_account) { "acc-12345" }
    let(:client_alias) { email }

    context "" do
      let(:argv) { ["config", "user_add"] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "when NO config file on disk", :vcr do
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        config_file = File.join(ENV["HOME"], ".brightbox", "config")
        FileUtils.rm_rf(config_file)
        expect(File.exists?(config_file)).to be_false
        mock_password_entry(password)
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(client_alias)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end
    end

    context "when passing in required arguments", :vcr do
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(client_alias)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end

      it "requests access tokens" do
        config_from_contents("")
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => email

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end

      it "does not prompt to rerun the command" do
        expect(stderr).to_not include("please re-run your command")
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end
    end

    context "when passing in required arguments and api_url", :vcr do
      let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql(api_url)
        expect(@client_section["alias"]).to eql(client_alias)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end

      it "requests access tokens" do
        config_from_contents("")
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => email

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end
    end

    context "when application details in config", :vcr do
      let(:revised_alias) { "#{client_alias}_1" }
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        contents = <<-EOS
        [#{client_alias}]
        alias = #{client_alias}
        client_id = #{client_id}
        secret = #{secret}
        username = #{email}
        EOS
        config_from_contents(contents)
        mock_password_entry(password)
      end


      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[revised_alias]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(revised_alias)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end
    end

    context "when application has access to multiple accounts", :vcr do
      # Hardcoded in response, different from single account value
      let(:default_account) { "acc-54321" }
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end

      it "display an warning about preselected default" do
        expect { output }.to_not raise_error
        expect(stderr).to include("The default account of #{default_account} has been selected")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(email)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        # Hardcoded in VCR response of multiple accounts
        expect(@client_section["default_account"]).to eql(default_account)
      end
    end


    context "when application has access only one active account", :vcr do
      # Hardcoded in response, different from single account value
      let(:default_account) { "acc-33333" }
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end

      it "display an warning about preselected default" do
        expect { output }.to_not raise_error
        expect(stderr).to include("The default account of #{default_account} has been selected")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(email)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
      end

      it "selects the active account for the default" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[email]

        # Hardcoded in VCR response of multiple accounts
        expect(@client_section["default_account"]).to eql(default_account)
      end
    end

    context "when client_id argument format is incorrect" do
      let(:client_id) { "whatever" }
      let(:argv) { ["config", "user_add", email, client_id, secret] }

      it "raises an error including the bad argument" do
        expect(stderr).to include("ERROR: The client-id '#{client_id}' must match the format app-xxxxx")
      end
    end
  end
end
