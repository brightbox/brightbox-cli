require "spec_helper"

describe Brightbox::BBConfig do

  describe "#config_directory" do
    context "when default location is used" do
      it "returns a String of the users `.brightbox` directory" do
        config = Brightbox::BBConfig.new

        expanded_path = File.expand_path("~/.brightbox")
        expect(config.config_directory).to eql(expanded_path)
      end
    end

    context "when absolute custom location is set" do
      it "returns a String of the expanded directory" do
        config_options = {
          :directory => "/etc/local/brightbox_cli"
        }
        config = Brightbox::BBConfig.new(config_options)

        expect(config.config_directory).to eql("/etc/local/brightbox_cli")
      end
    end

    context "when custom config location is set" do
      it "returns a String of the expanded directory" do
        config_options = {
          :directory => "~/.cli_config"
        }
        config = Brightbox::BBConfig.new(config_options)

        expanded_path = File.expand_path("~/.cli_config")
        expect(config.config_directory).to eql(expanded_path)
      end
    end
  end
end
