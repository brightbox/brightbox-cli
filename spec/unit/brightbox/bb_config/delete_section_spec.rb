require "spec_helper"

describe Brightbox::BBConfig do

  describe "#delete_section" do
    let(:client_name) { "removable" }

    context "when section is exists" do
      let(:contents) do
        <<-EOS
        [core]
        default_client = removable
        [removable]
        key = value
        EOS
      end

      before do
        @config = config_from_contents(contents)
      end

      it "removes it from the config" do
        expect(config_file_contents).to include("[#{client_name}]")
        @config.delete_section(client_name)
        expect(config_file_contents).to_not include("[#{client_name}]")
      end

      it "removes the default" do
        expect(@config.default_client).to eql(client_name)
        @config.delete_section(client_name)
        expect(@config.default_client).to eql(nil)
      end
    end

    context "when section does not exist" do
      let(:contents) { "" }

      before do
        @config = config_from_contents(contents)
      end

      it "does not change the config" do
        original_contents = config_file_contents
        @config.delete_section(client_name)
        expect(config_file_contents).to eql(original_contents)
      end
    end
  end
end
