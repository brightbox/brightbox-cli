require "spec_helper"
require "tmpdir"

describe Brightbox::BBConfig do

  describe "#config_directory_exists?" do
    let(:config) { Brightbox::BBConfig.new(:directory => @dir) }

    context "when directory exists" do
      it "returns true" do
        Dir.mktmpdir do |dir|
          @dir = dir
          expect(config.config_directory_exists?).to be_true
        end
      end
    end

    context "when a file exists with the name" do
      it "returns false" do
        Tempfile.open("config_clash") do |tmp_file|
          @dir = tmp_file.path
          expect(config.config_directory_exists?).to be_false
        end
      end
    end

    context "when directory does not exist" do
      it "returns false" do
        @dir = "fnord"
        expect(config.config_directory_exists?).to be_false
      end
    end
  end
end
