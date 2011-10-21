require "spec_helper"

describe "Cloud IP" do

  describe "listing cloud ips" do
    use_vcr_cassette("list_cloud_ip")

    it "should list cloud ips" do
      ips = Brightbox::CloudIP.find(:all)
      output = capture_stdout {
        Brightbox.render_table(ips.sort, :vertical => true)
      }
      output.should match(/cip-33fjw/)
    end
  end

end
