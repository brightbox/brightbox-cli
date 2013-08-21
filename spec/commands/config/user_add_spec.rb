require "spec_helper"

describe "brightbox config" do

  describe "user_add" do
    let(:output) { FauxIO.new { Brightbox::run(argv) } }
    let(:stdout) { output.stdout }
    let(:stderr) { output.stderr }

    context "" do
      let(:argv) { ["config", "user_add"] }

      it "does not error" do
        expect { output }.to_not raise_error
      end
    end
  end
end
