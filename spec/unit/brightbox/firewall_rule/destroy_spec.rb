require "spec_helper"

describe Brightbox::FirewallRule do

  describe "#destroy", :vcr, :broken_1_8 do
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
        expect {
          @rule.destroy
        }.to_not raise_error
      end
    end
  end
end
