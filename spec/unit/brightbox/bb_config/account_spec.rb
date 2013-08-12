require "spec_helper"

describe Brightbox::BBConfig do

  describe "#account" do
    context "when config has no default account", :vcr do
      before do
        @config = Brightbox::BBConfig.new :directory => API_CLIENT_CONFIG_DIR
      end

      it "returns the configured default" do
        # Embedded in VCR recording
        expect(@config.account).to eql("acc-12345")
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
        @tmp_config = TmpConfig.new(contents)
        @config = Brightbox::BBConfig.new :directory => @tmp_config.path

        # Never hit the API
        expect(Brightbox::Account).to_not receive(:all)
      end

      it "returns the configured default" do
        expect(@config.account).to eql(@account_name)
      end

      after do
        @tmp_config.close
      end
    end
  end
end
