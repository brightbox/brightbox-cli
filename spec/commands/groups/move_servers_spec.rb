require "spec_helper"

describe "brightbox groups" do
  describe "move_servers" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { %w[groups move_servers] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
