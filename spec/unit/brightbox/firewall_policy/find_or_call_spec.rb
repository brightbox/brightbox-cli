require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#find_or_call" do
    use_vcr_cassette('show_firewall_policy')

    it "should show firewall policy" do
      output = capture_stdout {
        firewall_policy = Brightbox::FirewallPolicy.find_or_call(["fwp-3q9jp"])
        Brightbox.render_table(firewall_policy,:vertical => true)
      }
      output.should match(/default_permissive_policy/)
    end
  end
end
