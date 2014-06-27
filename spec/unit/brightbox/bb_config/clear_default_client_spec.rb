require "spec_helper"

describe Brightbox::BBConfig do

  describe "#clear_default_client" do
    context "when default client is set" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = fnord

        [fnord]
        key = value
        EOS
      end

      before do
        @config = config_from_contents(contents)
      end

      it "does alters the value" do
        expect do
          @config.clear_default_client
        end.to change(@config, :default_client)
        expect(@config.default_client).to be_nil
      end

      it "dirties the config" do
        expect do
          @config.clear_default_client
        end.to change(@config, :dirty?)
      end
    end

    context "when default client is not set" do
      before do
        remove_config
        @config = Brightbox::BBConfig.new
      end

      it "does not alter the value" do
        expect do
          @config.clear_default_client
        end.to_not change(@config, :default_client)
      end

      it "does not dirty the config" do
        expect do
          @config.clear_default_client
        end.to_not change(@config, :dirty?)
      end
    end
  end
end
