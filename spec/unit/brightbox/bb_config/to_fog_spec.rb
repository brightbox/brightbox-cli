require "spec_helper"
require "tempfile"

describe Brightbox::BBConfig do
  describe "#to_fog" do
    context "For Api Clients" do
      it "should return correct fog options" do
        config = Brightbox::BBConfig.new()
        config.stubs(:config_filename).returns(client_base_config.path)

        config.client_name = "cli-abcde"
        config.to_fog.should_not be_empty

        fog_config = config.to_fog
        fog_config[:brightbox_secret].should == "abcde"
        fog_config[:provider].should == "Brightbox"
        fog_config[:brightbox_client_id].should == "cli-abcde"
      end
      it "should throw error if api client is not configured" do
        config = Brightbox::BBConfig.new()
        config.stubs(:config_filename).returns(client_base_config.path)

        config.client_name = "cli-12345"
        lambda {
          config.to_fog
        }.should raise_error(Brightbox::BBConfigError)
      end
    end

    context "For User applications" do
      it "should return correct fog options" do
        config = Brightbox::BBConfig.new()
        config.stubs(:config_filename).returns(app_base_config.path)

        config.client_name = "app-12345"
        fog_config = config.to_fog

        fog_config.should_not be_empty
        fog_config[:provider].should == "Brightbox"
      end
      it "should throw error if user application is not configured" do
        config = Brightbox::BBConfig.new()
        config.stubs(:config_filename).returns(app_base_config.path)

        config.client_name = "app-abcde"
        lambda {
          config.to_fog
        }.should raise_error(Brightbox::BBConfigError)
      end
    end
  end

  describe "updating refresh token on exit" do
    it "should only update the token if it is non-empty" do
      config = Brightbox::BBConfig.new()
      config.stubs(:config_filename).returns(client_base_config.path)

      config.expects(:save!).never
      config.finish
    end
  end

  def app_base_config
    config_content =<<-EOD
[app-12345]
alias = app-12345
app_id = app-12345
app_secret = abcdef
api_url = https://api.gb1.brightbox.com
auth_url = https://api.gb1.brightbox.com
refresh_token = whoa
    EOD
    Tempfile.new("foo").tap { |t|
      t.write(config_content)
      t.close
    }
  end

  def client_base_config
    config_content =<<-EOD
[cli-abcde]
client_id = cli-abcde
secret = abcde
api_url = http://www.example.com
auth_url = http://www.example.com
    EOD
    t = Tempfile.new("foo")
    t.write(config_content)
    t.close
    t
  end
end
