require "spec_helper"

describe "brightbox config" do
  describe "client_list" do
    let(:output) { FauxIO.new { Brightbox.run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { %w[config client_list] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
