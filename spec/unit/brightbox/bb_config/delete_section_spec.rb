require "spec_helper"

describe Brightbox::BBConfig do

  describe "#delete_section" do
    let(:client_name) { "removable" }
    let(:config) { config_from_contents(contents) }

    context "when section is exists" do
      let(:contents) do
        <<-EOS
        [removable]
        key = value
        EOS
      end

      it "removes it from the config" do
        expect(config_file_contents).to match("[removable]")
        config.delete_section(client_name)
        expect(config_file_contents).to_not match("[removable]")
      end
    end

    context "when section does not exist" do
      let(:contents) { "" }

      it "does not change the config" do
        config.delete_section(client_name)
        expect(config_file_contents).to eql("")
      end
    end
  end
end
