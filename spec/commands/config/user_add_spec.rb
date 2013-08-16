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

    context "" do
      let(:argv) { ["config", "user_add"] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "email client_id secret", :vcr do
      let(:argv) { ["config", "user_add", email, client_id, secret] }
      #let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[client_id]

        expect(@client_section["api_url"]).to eql("https://api.gb1.brightbox.com")
        expect(@client_section["alias"]).to eql(client_id)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
      end

      it "requests access tokens" do
        config_from_contents("")
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => client_id

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end
    end

    context "email client_id secret api_url", :vcr do
      let(:argv) { ["config", "user_add", email, client_id, secret, api_url] }

      before do
        mock_password_entry(password)
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[client_id]

        expect(@client_section["api_url"]).to eql(api_url)
        expect(@client_section["alias"]).to eql(client_id)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
      end

      it "requests access tokens" do
        config_from_contents("")
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new :client_name => client_id

        expect(cached_access_token(@config)).to eql(@config.access_token)
        expect(cached_refresh_token(@config)).to eql(@config.refresh_token)
      end

      it "does not error" do
        expect { output }.to_not raise_error
        expect(stderr).to_not include("ERROR")
      end
    end
  end
end
