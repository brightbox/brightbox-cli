require "spec_helper"

describe "brightbox groups" do
  describe "add_server" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { %w[groups add_server] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
