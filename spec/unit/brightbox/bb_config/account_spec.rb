require "spec_helper"

describe Brightbox::BBConfig do

  describe "#account" do
    context "when passed as an option" do
      before do
        @account_name = "acc-kll54"
        @config = Brightbox::BBConfig.new(:account => @account_name)
      end

      it "returns the passed version" do
        expect(@config.account).to eql(@account_name)
      end
    end

    context "when config has no default account" do
      before do
        contents = <<-EOS
        [core]
        default_client = default
        [default]
        key = value
        EOS
        @config = config_from_contents(contents)
      end

      it "returns nil" do
        expect(@config.account).to be_nil
      end
    end

    context "when config has a default account set" do
      before do
        @account_name = "acc-ghj32"
        @client_name = "app-b3n5b"
        contents =<<-EOS
        [#{@client_name}]
        default_account = #{@account_name}
        EOS
        @config = config_from_contents(contents)

        # Never hit the API
        expect(Brightbox::Account).to_not receive(:all)
      end

      it "returns the configured default" do
        expect(@config.account).to eql(@account_name)
      end

      it "does not dirty the config" do
        expect {
          @config.account
        }.to_not change(@config, :dirty?)
      end
    end
  end
end
