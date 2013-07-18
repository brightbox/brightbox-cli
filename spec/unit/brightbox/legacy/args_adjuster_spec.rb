require "spec_helper"
require "brightbox-cli/legacy/args_adjuster"

describe Brightbox::Legacy::ArgsAdjuster do

  describe "#for_command" do
    let(:adjuster) { Brightbox::Legacy::ArgsAdjuster.new(args) }

    context "when account global switch is used" do
      let(:args) { ["--account", "acc-12345", "show", "srv-12345"] }

      it "inserts after global args" do
        expected = ["--account", "acc-12345", "command", "show", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when client global switch is used" do
      let(:args) { ["-c", "staging", "show", "srv-12345"] }

      it "inserts after global args" do
        expected = ["-c", "staging", "command", "show", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when simple global flag is used" do
      let(:args) { ["--simple", "show", "srv-12345"] }

      it "inserts after global args" do
        expected = ["-s", "command", "show", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when insecure global switch is used" do
      let(:args) { ["-k", "show", "srv-12345"] }

      it "inserts after global args" do
        expected = ["-k", "command", "show", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when many args are passed" do
      let(:args) { ["-k", "--simple", "-c", "prod", "subcommand", "srv-12345"] }

      it "inserts after global args" do
        expected = ["-k", "-s", "-c", "prod", "command", "subcommand", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when no global args are used" do
      let(:args) { ["show", "srv-12345"] }

      it "inserts at the front" do
        expected = ["command", "show", "srv-12345"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end

    context "when no args are used" do
      let(:args) { [] }

      it "inserts at the front" do
        expected = ["command"]
        expect(adjuster.for_command "command").to eql(expected)
      end
    end
  end
end
