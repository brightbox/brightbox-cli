require "spec_helper"

describe Brightbox::BBConfig do

  describe "#finish" do
    context "when refresh token is empty" do
      before do
        @config = Brightbox::BBConfig.new
      end

      it "delegates saving the refresh token" do
        expect(@config).to receive(:save_access_token)
        expect(@config).to receive(:save_refresh_token)
        expect(@config).to receive(:write_config_file)
        @config.finish
      end
    end
  end
end
