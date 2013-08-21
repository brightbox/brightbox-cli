require "spec_helper"

describe "brightbox config" do

  describe "client_add" do
    let(:output) { FauxIO.new { Brightbox::run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { ["config", "client_add"] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
