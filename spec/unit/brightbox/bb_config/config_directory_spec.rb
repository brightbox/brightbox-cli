require "spec_helper"

describe Brightbox::BBConfig do
  describe "#config_directory" do
    context "when HOME is not set" do
      let(:working_dir) { Dir.mktmpdir("working") }

      before do
        allow(Dir).to receive(:pwd).and_return(working_dir)
        allow(ENV).to receive(:fetch).with("HOME", nil).and_return(nil)
      end

      it "returns current directory" do
        config = Brightbox::BBConfig.new

        expect(config.config_directory).to start_with(working_dir)
        expect(config.config_directory).to end_with(".brightbox")
      end
    end

    context "when default location is used" do
      it "returns a String of the users `.brightbox` directory" do
        config = Brightbox::BBConfig.new

        expanded_path = File.expand_path("~/.brightbox")
        expect(config.config_directory).to eq(expanded_path)
      end
    end

    context "when absolute custom location is set" do
      let(:custom_dir) { Dir.mktmpdir("custom") }

      after do
        FileUtils.rm_rf(custom_dir)
      end

      it "returns a String of the expanded directory" do
        config_options = {
          :directory => custom_dir
        }
        config = Brightbox::BBConfig.new(config_options)

        expect(config.config_directory).to eq(custom_dir)
      end
    end

    context "when custom config location is set" do
      it "returns a String of the expanded directory" do
        config_options = {
          :directory => "~/.cli_config"
        }
        config = Brightbox::BBConfig.new(config_options)

        expanded_path = File.expand_path("~/.cli_config")
        expect(config.config_directory).to eq(expanded_path)
      end
    end
  end
end
