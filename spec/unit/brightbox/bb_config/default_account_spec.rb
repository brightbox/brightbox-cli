require "spec_helper"

describe Brightbox::BBConfig do

  describe "#default_account" do
    context "when not available in config" do
      before do
        contents =<<-EOS
        [app-12345]
        EOS
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns nil" do
        expect(@config.default_account).to be_nil
      end

      after do
        @tmp_config.close
      end
    end

    context "when blank in config" do
      before do
        contents =<<-EOS
        [app-12345]
        default_account = 
        EOS
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns nil" do
        expect(@config.default_account).to be_nil
      end

      after do
        @tmp_config.close
      end
    end

    context "when set in config" do
      before do
        @account_name = "acc-ghj32"
        @client_name = "app-b3n5b"
        contents =<<-EOS
        [#{@client_name}]
        default_account = #{@account_name}
        EOS
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path
      end

      it "returns the configured default" do
        expect(@config.default_account).to eql(@account_name)
      end

      after do
        @tmp_config.close
      end
    end
  end
end
