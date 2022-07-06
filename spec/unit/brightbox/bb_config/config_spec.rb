require "spec_helper"
require "tmpdir"
require "tempfile"

describe Brightbox::BBConfig do
  describe "#config" do
    context "when config directory is missing" do
      around do |example|
        Dir.mktmpdir do |tmp_dir|
          target_dir = File.join(tmp_dir, "config")
          @config = Brightbox::BBConfig.new :directory => target_dir
          example.run
        end
      end

      it "returns a key/valued object" do
        expect(@config.config).to respond_to(:[])
      end

      it "creates the config directory" do
        expect { @config.config }.to_not raise_error
        expect(@config.config_directory_exists?).to be true
      end
    end

    context "when config file exists" do
      around do |example|
        Dir.mktmpdir do |target_dir|
          test_config_filename = File.join(target_dir, "config")
          File.open(test_config_filename, "w") do |f|
            f.puts "[core]"
            f.puts "key = setting"
          end

          @config = Brightbox::BBConfig.new :directory => target_dir
          example.run
        end
      end

      it "returns a key/valued object" do
        expect(@config.config).to respond_to(:[])
      end

      it "has set the values from the config" do
        @config.config
        expect(@config["core"]["key"]).to eql("setting")
      end
    end

    # FIXME: This appears to be current behaviour, at least under testing which
    #   seems a bit off. Might be an issue with the setup because I did have
    #   failures initially.
    context "when config dir exists as a file" do
      it "does not raise an error" do
        Tempfile.open("tmp") do |target_dir|
          @config = Brightbox::BBConfig.new :directory => target_dir.path
          expect { @config.config }.to_not raise_error
        end
      end
    end

    context "when config file can not be parsed" do
      it "raises an error" do
        Dir.mktmpdir do |target_dir|
          test_config_filename = File.join(target_dir, "config")
          File.open(test_config_filename, "w") do |f|
            f.puts "not:ini"
          end

          expect do
            @config = Brightbox::BBConfig.new :directory => target_dir
          end.to raise_error(Brightbox::BBConfigError)
        end
      end
    end
  end
end
