require "spec_helper"

describe Brightbox::BBConfig do

  describe "#default_client" do
    context "when config file is empty" do
      before do
        contents = ""
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns the configured default" do
        expect(@config.default_client).to be_nil
      end

      after do
        @tmp_config.close
      end
    end

    context "when config file has no default" do
      before do
        contents =<<-EOS
        [core]
        EOS
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns the configured default" do
        expect(@config.default_client).to be_nil
      end

      after do
        @tmp_config.close
      end
    end

    context "when config file contains a default client" do
      before do
        @client_name = "app-b3n5b"
        contents =<<-EOS
        [core]
        default_client = #{@client_name}
        EOS
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns the configured default" do
        expect(@config.default_client).to eql(@client_name)
      end

      after do
        @tmp_config.close
      end
    end
  end
end
