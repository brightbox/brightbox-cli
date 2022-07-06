require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe ".from_policy", vcr: true do
    context "when policy exists with a rule" do
      before do
        policy_options = {}
        @policy = Brightbox::FirewallPolicy.create(policy_options)

        rule_options = {
          :destination => "0.0.0.0/0",
          :protocol => "tcp",
          :firewall_policy_id => @policy.id
        }
        rule_1_options = rule_options.merge(:destination_port => "1080")
        @rule_one = Brightbox::FirewallRule.create rule_1_options

        rule_2_options = rule_options.merge(:destination_port => "1081")
        @rule_two = Brightbox::FirewallRule.create rule_2_options
      end

      it "lists all rules" do
        # FIXME: from_policy does not seem to reload from API so uses a stale
        #   representation of the rules (Policy creation above)
        @policy.reload
        @policy_rules = Brightbox::FirewallRules.from_policy(@policy)

        output = FauxIO.new do
          Brightbox.render_table(@policy_rules, :vertical => true)
        end
        expect(output.stdout).to include("id: #{@rule_one.id}")
        expect(output.stdout).to include("dport: 1080")

        expect(output.stdout).to include("id: #{@rule_two.id}")
        expect(output.stdout).to include("dport: 1081")
      end

      after do
        @policy.destroy
      end
    end
  end
end
