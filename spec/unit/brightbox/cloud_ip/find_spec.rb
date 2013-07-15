require "spec_helper"

describe Brightbox::CloudIP do

  describe "#find(:all)" do
    use_vcr_cassette("list_cloud_ip")

    context "when a Cloud IP exists" do
      it "should list cloud ips" do
        ips = Brightbox::CloudIP.find(:all)
        output = capture_stdout {
          Brightbox.render_table(ips.sort, :vertical => true)
        }
        output.should match(/cip-6r5a4/)
      end
    end
  end
end
