require "spec_helper"

describe Brightbox::BBConfig do

  context "when config is clean" do
    let(:config) { Brightbox::BBConfig.new }

    before do
      Ini.any_instance.should_not_receive(:write)
      expect(config).to_not be_dirty
    end

    it "does not raise an error" do
      expect { config.save }.to_not raise_error
    end

    it "does not write to disk" do
      config.save
      expect(config).to_not be_dirty
    end
  end

  context "when config is dirty" do
    let(:config) { Brightbox::BBConfig.new }

    before do
      Ini.any_instance.should_receive(:write)
      config.dirty!
    end

    it "does not raise an error" do
      expect { config.save }.to_not raise_error
    end

    it "removes the dirty flag" do
      config.save
      expect(config).to_not be_dirty
    end
  end
end
