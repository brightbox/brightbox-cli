require "spec_helper"

describe Brightbox::BBConfig do
  let(:api_client_id) { "cli-12345" }
  let(:user_client_id) { "app-12345" }
  let(:user_app_two) { "app-54321" }

  let(:contents) do
    <<-EOS
    [#{api_client_id}]
    client_id = #{api_client_id}
    secret = #{random_token}
    [#{user_client_id}]
    client_id = #{user_client_id}
    secret = #{random_token}
    [#{user_app_two}]
    client_id = #{user_app_two}
    secret = #{random_token}
    EOS
  end

  let(:config) { config_from_contents(contents) }
  let(:error_message) { Brightbox::NO_CLIENT_MESSAGE }

  describe "#using_application?" do
    context "when no config is saved" do
      before do
        remove_config
      end

      it "does not raise an error" do
        expect do
          Brightbox::BBConfig.new.using_application?
        end.to raise_error(Brightbox::NoSelectedClientError, error_message)
      end
    end

    context "when selected config is for a user application" do
      let(:client_name) { user_client_id }

      it "returns true" do
        config.client_name = client_name
        expect(config.using_application?).to be true
      end
    end

    context "when selected config is for an API client" do
      let(:client_name) { api_client_id }

      it "returns false" do
        config.client_name = client_name
        expect(config.using_application?).to be false
      end
    end

    context "when selected config is for a user application with generic key" do
      let(:client_name) { user_app_two }

      it "returns true" do
        config.client_name = client_name
        expect(config.using_application?).to be true
      end
    end
  end

  describe "#using_api_client?" do
    context "when no config is saved" do
      before do
        remove_config
      end

      it "does not raise an error" do
        expect do
          Brightbox::BBConfig.new.using_api_client?
        end.to raise_error(Brightbox::NoSelectedClientError, error_message)
      end
    end

    context "when selected config is for a user application" do
      let(:client_name) { user_client_id }

      it "returns false" do
        config.client_name = client_name
        expect(config.using_api_client?).to be false
      end
    end

    context "when selected config is for an API client" do
      let(:client_name) { api_client_id }

      it "returns true" do
        config.client_name = client_name
        expect(config.using_api_client?).to be true
      end
    end

    context "when selected config is for a user application with generic key" do
      let(:client_name) { user_app_two }

      it "returns false" do
        config.client_name = client_name
        expect(config.using_api_client?).to be false
      end
    end
  end
end
