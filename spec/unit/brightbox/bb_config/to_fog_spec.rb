require "spec_helper"
require "tempfile"

describe Brightbox::BBConfig do
  describe "#to_fog" do
    let(:fog_config) { config_from_contents(contents).to_fog }

    context "For Api Clients" do
      let(:contents) { API_CLIENT_CONFIG_CONTENTS }

      it "should return correct fog options" do
        fog_config[:brightbox_secret].should == "qy6xxnvy4o0tgv5"
        fog_config[:provider].should == "Brightbox"
        fog_config[:brightbox_client_id].should == "cli-12345"
      end

      it "should throw error if api client is not configured" do
        config = Brightbox::BBConfig.new
        #allow(config).to receive(:config_filename).and_return(client_base_config.path)

        config.client_name = "cli-12345"
        expect {
          config.to_fog
        }.to raise_error(Brightbox::BBConfigError)
      end
    end

    context "For User applications" do
      let(:contents) { USER_APP_CONFIG_CONTENTS }

      it "should return correct fog options" do
        fog_config.should_not be_empty
        fog_config[:provider].should == "Brightbox"
      end

      it "should throw error if user application is not configured" do
        config = Brightbox::BBConfig.new

        # FIXME In order to get the error, the client name must be set
        #   not having a client name should also be a configuration error
        config.client_name = "app-12345"

        expect {
          config.to_fog
        }.to raise_error(Brightbox::BBConfigError)
      end
    end
  end
end
