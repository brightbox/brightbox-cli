require "spec_helper"

describe Brightbox::BBConfig do

  describe "#default_account" do
    context "when no config file is available" do
      before do
        remove_config
      end

      it "does not raise an error" do
        expect {
          Brightbox::BBConfig.new.default_account
        }.to_not raise_error
      end
    end

    context "when not available in config" do
      before do
        contents =<<-EOS
        [app-12345]
        EOS
        @config = config_from_contents(contents)
      end

      it "returns nil" do
        expect(@config.default_account).to be_nil
      end
    end

    context "when blank in config" do
      before do
        contents =<<-EOS
        [app-12345]
        default_account = 
        EOS
        @config = config_from_contents(contents)
      end

      it "returns nil" do
        expect(@config.default_account).to be_nil
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
        @config = config_from_contents(contents)
      end

      it "returns the configured default" do
        expect(@config.default_account).to eql(@account_name)
      end
    end
  end
end
