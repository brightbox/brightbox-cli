require "spec_helper"

describe Brightbox::BBConfig, "#section_names" do
  subject(:config) { config_from_contents(ini) }

  context "when no sections exist" do
    let(:ini) { "" }
    it { expect(config.section_names).to eql("") }
  end

  context "when only a 'core' section exists" do
    let(:ini) do
      <<-EOS
      [core]
      setting = value
      EOS
    end
    it { expect(config.section_names).to eql("") }
  end

  context "when only an 'alias' section exists" do
    let(:ini) do
      <<-EOS
      [alias]
      setting = value
      EOS
    end
    it { expect(config.section_names).to eql("") }
  end

  context "when multiple sections exist" do
    let(:ini) do
      <<-EOS
      [core]
      setting = value

      [cli-12345]
      setting = value

      [app-12345]
      setting = value
      EOS
    end
    it { expect(config.section_names).to eq(%w(cli-12345 app-12345)) }
  end
end
