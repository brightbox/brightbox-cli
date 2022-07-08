require "spec_helper"
require "brightbox-cli/legacy/args_adjuster"

describe Brightbox::Legacy::ArgsAdjuster do
  describe "#for_command" do
    let(:adjuster) { Brightbox::Legacy::ArgsAdjuster.new(args) }

    context "when account global switch is used" do
      let(:args) { %w[--account acc-12345 show srv-12345] }

      it "inserts after global args" do
        expected = %w[--account acc-12345 command show srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when client global switch is used" do
      let(:args) { %w[-c staging show srv-12345] }

      it "inserts after global args" do
        expected = %w[-c staging command show srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when simple global flag is used" do
      let(:args) { %w[--simple show srv-12345] }

      it "inserts after global args" do
        expected = %w[-s command show srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when insecure global switch is used" do
      let(:args) { %w[-k show srv-12345] }

      it "inserts after global args" do
        expected = %w[-k command show srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when many args are passed" do
      let(:args) { %w[-k --simple -c prod subcommand srv-12345] }

      it "inserts after global args" do
        expected = %w[-k -s -c prod command subcommand srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when no global args are used" do
      let(:args) { %w[show srv-12345] }

      it "inserts at the front" do
        expected = %w[command show srv-12345]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when no args are used" do
      let(:args) { [] }

      it "inserts at the front" do
        expected = ["command"]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end

    context "when subcommands have their own options" do
      let(:args) { ["-k", "create", "-n", "Disk test", "img-12345"] }

      it "doesn't raise an error" do
        expected = ["-k", "command", "create", "-n", "Disk test", "img-12345"]
        expect(adjuster.for_command("command")).to eql(expected)
      end
    end
  end
end
