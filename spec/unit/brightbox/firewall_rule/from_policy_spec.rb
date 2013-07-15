require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    @policy_id = "fwp-30kea"
  end

  describe ".from_policy" do
    use_vcr_cassette('firewall_rule_list')

    before do
      @firewall_policy = Brightbox::FirewallPolicy.find(@policy_id)
      @firewall_rules = Brightbox::FirewallRules.from_policy(@firewall_policy)
    end

    it "should list all rules" do
      output = capture_stdout {
        Brightbox.render_table(@firewall_rules,:vertical => true)
      }
      output.should match(/1080/)
    end
  end
end
