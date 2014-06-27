require "spec_helper"

describe Brightbox::BBConfig do
  let(:contents) do
    <<-EOS
    [core]
    default_client = fnord

    [fnord]
    client_id = cli-12345
    alias = test

    [jason.null@brightbox.com]
    client_id = app-12345
    alias = dev
    EOS
  end
  let(:config) { config_from_contents(contents) }

  describe "#client_named?" do
    context "when no client with that name" do
      it "returns false" do
        expect(config.client_named?("missing")).to be false
      end
    end

    context "when client with that ID exists" do
      it "returns false" do
        expect(config.client_named?("cli-12345")).to be false
      end
    end

    context "when client with that alias exists" do
      it "returns true" do
        expect(config.client_named?("test")).to be true
      end
    end

    context "when client with that alias exists" do
      it "returns true" do
        expect(config.client_named?("dev")).to be true
      end
    end

    context "when client a section header exists" do
      it "returns true" do
        expect(config.client_named?("jason.null@brightbox.com")).to be true
      end
    end

    context "when client is named 'core'" do
      it "returns false" do
        expect(config.client_named?("core")).to be false
      end
    end
  end
end
