require "spec_helper"

describe Brightbox::BBConfig do

  describe "#default_client" do
    context "when config file is empty" do
      before do
        remove_config
        @config = Brightbox::BBConfig.new
      end

      it "returns the configured default" do
        expect(@config.default_client).to be_nil
      end
    end

    context "when config file has no default" do
      before do
        contents = <<-EOS
        [core]
        EOS
        @tmp_config = config_from_contents(contents)
        @config = config_from_contents(contents)
      end

      it "returns the configured default" do
        expect(@config.default_client).to be_nil
      end
    end

    context "when config file contains a default client" do
      before do
        @client_name = "app-b3n5b"
        contents = <<-EOS
        [core]
        default_client = #{@client_name}
        EOS
        @config = config_from_contents(contents)
      end

      it "returns the configured default" do
        expect(@config.default_client).to eql(@client_name)
      end
    end
  end
end
