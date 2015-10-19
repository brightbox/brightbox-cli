require "spec_helper"

describe Brightbox::CloudIP do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#find(:all)" do
    context "when a Cloud IP exists" do
      before do
        @cip = Brightbox::CloudIP.create
      end

      it "returns a suitable", vcr: true do
        ips = Brightbox::CloudIP.find(:all)
        output = FauxIO.new do
          Brightbox.render_table(ips.sort, :vertical => true)
        end
        expect(output.stdout).to include(@cip.id)
      end

      after do
        @cip.destroy
      end
    end
  end
end
