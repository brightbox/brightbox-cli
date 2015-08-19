require "spec_helper"

describe Brightbox::Config::UserApplication do
  let(:client_name) { "app-12345" }
  let(:secret) { random_token }

  let(:config) { config_from_contents(contents) }
  let(:config_section) { config[client_name] }

  subject(:section) { Brightbox::Config::UserApplication.new(config_section, client_name) }
  subject(:for_fog) { section.to_fog }

  describe "#to_fog" do
    context "when config is valid" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        client_id = #{client_name}
        secret = #{secret}
        username = user@example.com
        EOS
      end

      it "sets provider as 'Brightbox'" do
        expect(for_fog[:provider]).to eql("Brightbox")
      end

      it "sets API endpoint correctly" do
        expect(for_fog[:brightbox_api_url]).to eql("http://api.brightbox.dev")
      end

      it "copies API endpoint for auth endpoint correctly" do
        expect(for_fog[:brightbox_auth_url]).to eql("http://api.brightbox.dev")
      end

      it "sets client_id correctly" do
        expect(for_fog[:brightbox_client_id]).to eql(client_name)
      end

      it "sets secret correctly" do
        expect(for_fog[:brightbox_secret]).to eql(secret)
      end

      it "sets persistent correctly" do
        expect(for_fog[:persistent]).to be true
      end
    end

    context "when config has alternative auth endpoint" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        auth_url = http://auth.dev.brightbox.com
        client_id = #{client_name}
        secret = #{secret}
        username = user@example.com
        EOS
      end

      it "sets API endpoint correctly" do
        expect(for_fog[:brightbox_api_url]).to eql("http://api.brightbox.dev")
      end

      it "copies API endpoint for auth endpoint correctly" do
        expect(for_fog[:brightbox_auth_url]).to eql("http://auth.dev.brightbox.com")
      end
    end

    context "when config has persistence setting" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        client_id = #{client_name}
        secret = #{secret}
        username = user@example.com
        persistent = false
        EOS
      end

      it "sets persistent correctly" do
        expect(for_fog[:persistent]).to be false
      end
    end

    context "when config is missing api_url" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        client_id = #{client_name}
        secret = #{secret}
        username = user@example.com
        EOS
      end

      it "raises error" do
        expect { section.to_fog }.to raise_error(Brightbox::BBConfigError, "api_url option missing from config in section app-12345")
      end
    end

    context "when config is missing client_id" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        secret = #{secret}
        username = user@example.com
        EOS
      end

      it "raises error" do
        expect { section.to_fog }.to raise_error(Brightbox::BBConfigError, "client_id option missing from config in section app-12345")
      end
    end

    context "when config is missing secret" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        client_id = #{client_name}
        username = user@example.com
        EOS
      end

      it "raises error" do
        expect { section.to_fog }.to raise_error(Brightbox::BBConfigError, "secret option missing from config in section app-12345")
      end
    end

    context "when config is missing username" do
      let(:contents) do
        <<-EOS
        [#{client_name}]
        api_url = http://api.brightbox.dev
        client_id = #{client_name}
        secret = #{secret}
        EOS
      end

      it "raises error" do
        expect { section.to_fog }.to raise_error(Brightbox::BBConfigError, "username option missing from config in section app-12345")
      end
    end
  end
end
