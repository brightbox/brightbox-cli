require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    @policy_id = "fwp-30kea"
  end

  describe "#destroy" do
    use_vcr_cassette("firewall_rule_destroy")

    before do
      @firewall_rule = Brightbox::FirewallRule.find("fwr-tkklm")
    end

    it "should destroy a rule" do
      lambda do
        @firewall_rule.destroy
      end.should_not raise_error
    end
  end
end
