require "spec_helper"

describe TmpConfig do
  describe "#new(contents)" do
    it "creates a config file" do
      file_contents = "contents\ncontents"

      @tmp_config = TmpConfig.new(file_contents)
      tmp_config_file = File.join(@tmp_config.path, "config")
      expect(File.exist?(tmp_config_file)).to be true

      contents = File.read(tmp_config_file)
      expect(contents).to eql(file_contents)

      @tmp_config.close
    end
  end

  describe "#path" do
    it "returns a string" do
      @tmp_config = TmpConfig.new("contents")

      expect(@tmp_config.path).to be_kind_of(String)
      @tmp_config.close
    end
  end
end
