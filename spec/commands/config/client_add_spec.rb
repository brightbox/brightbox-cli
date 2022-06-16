require "spec_helper"

describe "brightbox config" do

  describe "client_add" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    let(:client_id) { "cli-12345" }
    let(:secret) { "qy6xxnvy4o0tgv5" }
    let(:api_url) { "http://api.brightbox.localhost" }

    let(:default_account) { "acc-12345" }

    context "" do
      let(:argv) { %w(config client_add) }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end

    context "when adding a new client", vcr: true do
      let(:argv) { ["config", "client_add", client_id, secret] }

      it "does not error" do
        expect(stderr).to_not include("ERROR")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[client_id]

        expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
        expect(@client_section["alias"]).to eql(client_id)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end
    end

    context "when new client is first and only client", vcr: true do
      let(:argv) { ["config", "client_add", client_id, secret] }

      before do
        remove_config
      end

      it "does not error" do
        expect(stderr).to_not include("ERROR")
      end

      it "sets up the config" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        @client_section = @config.config[client_id]

        expect(@client_section["api_url"]).to eql(Brightbox::DEFAULT_API_ENDPOINT)
        expect(@client_section["alias"]).to eql(client_id)
        expect(@client_section["client_id"]).to eql(client_id)
        expect(@client_section["secret"]).to eql(secret)
        expect(@client_section["default_account"]).to eql(default_account)
      end

      it "sets this as the default client" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        expect(@config.default_client).to eql(client_id)
      end
    end

    context "when new client is first and only client", vcr: true do
      let(:argv) { ["config", "client_add", client_id, secret] }

      it "does not change the default client" do
        expect { output }.to_not raise_error

        @config = Brightbox::BBConfig.new
        expect(@config.default_client).to eql(client_id)
      end
    end

    context "when client_id argument format is incorrect" do
      let(:argv) { ["config", "client_add", secret, client_id] }

      it "raises an error including the bad argument" do
        expect(stderr).to include("ERROR: The client-id '#{secret}' must match the format cli-xxxxx")
      end
    end
  end
end
