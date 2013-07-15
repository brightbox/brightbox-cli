require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#find(:all)" do
    use_vcr_cassette('list_firewall_policy')

    it "should list firewall policy" do
      output = capture_stdout {
        firewall_policies = Brightbox::FirewallPolicy.find(:all)
        Brightbox.render_table(firewall_policies,:vertical => true)
      }
      output.should match(/default_permissive_policy/)
    end
  end
end
