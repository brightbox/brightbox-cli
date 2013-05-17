require "spec_helper"

describe Brightbox::ConnectionManager do
  describe "without account" do
    it "should return a connection without account scope" do
      connection_manager = Brightbox::ConnectionManager.new(connection_options)
      connection = connection_manager.fetch_connection(false)
      connection.should_not be_nil
      connection.scoped_account.should be_nil
    end
  end

  describe "with account" do
    before do
      @connection_manager = Brightbox::ConnectionManager.new(connection_options)
    end

    it "should upgrade an existing connection with account if there is already a connection" do
      connection = @connection_manager.fetch_connection(false)
      connection.should_not be_nil

      Brightbox::CONFIG.expects(:account).returns("acc-abcde")
      connection2 = @connection_manager.fetch_connection(true)
      connection2.should == connection
      connection2.scoped_account.should_not be_nil
      connection2.scoped_account.should == "acc-abcde"
    end

    it "should pick default account by fetching from config file" do
      Brightbox::CONFIG.stubs(:selected_config).returns({ 'default_account' => "acc-12345"})
      connection = @connection_manager.fetch_connection(true)
      connection.should_not be_nil
      connection.scoped_account.should == "acc-12345"
    end
    it "should use single account of user, if he has only one" do
      Brightbox::CONFIG.unstub(:selected_config)
      mock_account = mock()
      mock_account.expects(:id).returns("acc-xyg")

      Brightbox::Account.expects(:all).returns([mock_account])

      connection = @connection_manager.fetch_connection(true)
      connection.should_not be_nil
      connection.scoped_account.should == "acc-xyg"
    end
  end

  def connection_options
    {
      :provider => "Brightbox",
      :brightbox_api_url => "http://www.example.com",
      :brightbox_auth_url => "http://www.example.com",
      :brightbox_client_id => "app-abcde",
      :brightbox_secret => "foobar",
      :brightbox_refresh_token => "emacsrocks"
    }
  end
end
