require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#destroy", vcr: true do
    context "when rule exists" do
      before do
        policy_options = {}
        @policy = Brightbox::FirewallPolicy.create(policy_options)

        rule_options = {
          :destination => "0.0.0.0/0",
          :destination_port => "1080",
          :protocol => "tcp",
          :firewall_policy_id => @policy.id
        }
        @rule = Brightbox::FirewallRule.create(rule_options)
      end

      it "destroys a rule" do
        expect do
          @rule.destroy
        end.to_not raise_error
      end
    end
  end
end
