require "spec_helper"

describe Brightbox::BBConfig do
  describe "#save_default_account" do
    context "when setting has not changed" do
      let(:account_id) { "acc-12345" }
      let(:config) do
        <<-EOS
        [core]
        default_client=cli-15243
        [cli-15243]
        default_account=#{account_id}
        EOS
      end

      before do
        @config = config_from_contents(config)
      end

      it "does not dirty the config" do
        @config.save_default_account(account_id)
        expect(@config).to_not be_dirty
      end
    end

    context "when setting has changed" do
      let(:account_id) { "acc-54321" }

      before do
        @config = config_from_contents(USER_APP_CONFIG_CONTENTS)
      end

      it "dirties the config" do
        @config.save_default_account(account_id)
        expect(@config).to be_dirty
      end
    end
  end
end
