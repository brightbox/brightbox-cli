require "spec_helper"

describe Brightbox::ConnectionManager, "#fetch_connection" do
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
      connection_manager.fetch_connection(false).should be_kind_of(Fog::Compute::Brightbox::Real)
    end

    it "returns a connection without account scope" do
      connection = connection_manager.fetch_connection(false)
      connection.should_not be_nil
      connection.scoped_account.should be_nil
    end
  end

  describe "when configuration file has an account" do
    context "when a connection exists" do
      it "upgrades existing connection with scoped account" do
        connection = connection_manager.fetch_connection(false)
        connection.should_not be_nil

        Brightbox::CONFIG.expects(:account).returns("acc-abcde")
        connection2 = connection_manager.fetch_connection(true)
        connection2.should == connection
        connection2.scoped_account.should_not be_nil
        connection2.scoped_account.should == "acc-abcde"
      end
    end
  end

  context "when a default account setting is set in config" do
    let(:default_account) { "acc-12345" }
    let(:selected_config) do
      {"default_account" => default_account}
    end

    it "selects configured account" do
      pending "Fails out of sequence, mocked config incorrect"
      Brightbox::CONFIG.stubs(:selected_config).returns({ 'default_account' => "acc-12345"})
      connection = connection_manager.fetch_connection(true)
      connection.should_not be_nil
      connection.scoped_account.should == "acc-12345"
    end
  end

  context "when user has one account" do
    it "selects that account" do
      pending "Fails out of sequence, mocked config incorrect"
      Brightbox::CONFIG.unstub(:selected_config)
      mock_account = mock()
      mock_account.expects(:id).returns("acc-xyg")

      Brightbox::Account.expects(:all).returns([mock_account])

      connection = connection_manager.fetch_connection(true)
      connection.should_not be_nil
      connection.scoped_account.should == "acc-xyg"
    end
  end
end
