require "spec_helper"

RSpec.describe Brightbox::Config, "#discover_two_factor_pin" do
  subject(:config) { config_from_contents(contents) }

  let(:api_url) { "http://api.brightbox.localhost" }
  let(:client_alias) { email }
  let(:default_account) { "acc-12345" }
  let(:email) { "jason.null@brightbox.com" }

  context "when 2FA is not enabled" do
    let(:contents) do
      <<-EOS
      [core]
      default_client = #{client_alias}

      [#{client_alias}]
      username = #{email}
      EOS
    end

    it "returns nil" do
      expect(config.discover_two_factor_pin).to be_nil
    end
  end

  context "when 2FA is enabled" do
    context "with password helper" do
      let(:cmd) { "fnord" }
      let(:contents) do
        <<-EOS
        [core]
        default_client = #{client_alias}

        [#{client_alias}]
        username = #{email}
        two_factor = true
        two_factor_helper_command = #{cmd}
        EOS
      end

      it "returns helper's response" do
        expect(IO).to receive(:popen).with([cmd], "r").and_return("111111")

        expect(config.discover_two_factor_pin).to eq("111111")
      end
    end

    context "with invalid password helper" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = #{client_alias}

        [#{client_alias}]
        username = #{email}
        two_factor = true
        two_factor_helper_command = #{cmd}
        EOS
      end

      context "when setting is empty" do
        let(:cmd) { nil }

        it "prompts for OTP" do
          mock_otp_entry("123456")

          expect(config.discover_two_factor_pin).to eq("123456")
        end
      end

      context "when command doesn't exist" do
        let(:cmd) { "fnord" }

        it "prompts for OTP" do
          expect(IO).to receive(:popen).with([cmd], "r").and_raise(Errno::ENOENT)
          mock_otp_entry("123456")

          expect(config.discover_two_factor_pin).to eq("123456")
        end
      end
    end

    context "without password helper" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = #{client_alias}

        [#{client_alias}]
        username = #{email}
        two_factor = true
        EOS
      end

      it "prompts for OTP" do
        mock_otp_entry("123456")

        expect(config.discover_two_factor_pin).to eq("123456")
      end
    end
  end
end
