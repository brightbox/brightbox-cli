require "spec_helper"

describe "brightbox groups" do

  describe "remove_servers" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { %w(groups remove_servers) }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
