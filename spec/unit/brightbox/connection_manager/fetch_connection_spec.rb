require "spec_helper"

describe Brightbox::ConnectionManager, "#fetch_connection" do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  let(:connection_manager) { Brightbox::ConnectionManager.new(connection_options) }
  let(:connection_options) do
    {
      :provider => "Brightbox",
      :brightbox_api_url => "http://www.example.com",
      :brightbox_auth_url => "http://www.example.com",
      :brightbox_client_id => "app-abcde",
      :brightbox_secret => "foobar",
      :brightbox_refresh_token => "emacsrocks"
    }
  end

  context "when not requesting a scoped connection" do
    it "returns a fog compute instance" do
      expect(connection_manager.fetch_connection(false)).to be_kind_of(Fog::Compute::Brightbox::Real)
    end

    it "returns a connection without account scope" do
      connection = connection_manager.fetch_connection(false)
      expect(connection).not_to be_nil
      expect(connection.scoped_account).to be_nil
    end
  end

  describe "when configuration file has an account" do
    context "when a connection exists" do
      it "upgrades existing connection with scoped account" do
        connection = connection_manager.fetch_connection(false)
        expect(connection).not_to be_nil

        expect(Brightbox.config).to receive(:account).and_return("acc-abcde")
        connection2 = connection_manager.fetch_connection(true)
        expect(connection2).to eq(connection)
        expect(connection2.scoped_account).not_to be_nil
        expect(connection2.scoped_account).to eq("acc-abcde")
      end
    end
  end

  context "when a default account setting is set in config" do
    let(:default_account) { "acc-12345" }
    let(:selected_config) do
      { "default_account" => default_account }
    end

    it "selects configured account" do
      skip "Fails out of sequence, mocked config incorrect"
      Brightbox.config.stubs(:selected_config).returns('default_account' => "acc-12345")
      connection = connection_manager.fetch_connection(true)
      expect(connection).not_to be_nil
      expect(connection.scoped_account).to eq("acc-12345")
    end
  end

  context "when user has one account" do
    it "selects that account" do
      skip "Fails out of sequence, mocked config incorrect"
      allow(Brightbox.config).to receive(:selected_config).and_call_original
      mock_account = double
      mock_account.expects(:id).returns("acc-xyg")

      Brightbox::Account.expects(:all).returns([mock_account])

      connection = connection_manager.fetch_connection(true)
      expect(connection).not_to be_nil
      expect(connection.scoped_account).to eq("acc-xyg")
    end
  end
end
