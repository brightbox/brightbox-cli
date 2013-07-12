require "spec_helper"

describe Brightbox::CloudIP do

  describe "#find(:all)" do
    context "when a Cloud IP exists" do
      before do
        @cip = Brightbox::CloudIP.create
      end

      it "returns a suitable", :vcr do
        ips = Brightbox::CloudIP.find(:all)
        output = capture_stdout {
          Brightbox.render_table(ips.sort, :vertical => true)
        }
        expect(output).to include(@cip.id)
      end

      after do
        @cip.destroy
      end
    end
  end
end
