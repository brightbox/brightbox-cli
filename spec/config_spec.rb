require "spec_helper"

describe Brightbox::BBConfig do
  describe "#to_fog" do
    context "For Api Clients" do
      it "should return correct fog options" do
        config = Brightbox::BBConfig.new()
        config.stubs(:config).returns(client_base_config)

        config.client_name = "cli-abcde"
        p config.to_fog
      end
      it "should throw error if api client is not configured"
    end

    context "For User applications" do
      it "should return correct fog options"
      it "should throw error if user application is not configured"
    end

    it "should detect type of authentication being used" do
      
    end
  end

  def client_base_config
    config_content =<<-EOD
[cli-abcde]
client_id = cli-abcde
secret = abcde
api_url = http://www.example.com
auth_url = http://www.example.com
    EOD
    t = Tempfile.new(config_content)

  end
end
