require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#find", vcr: true do
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
        @rule = Brightbox::FirewallRule.create rule_options
      end

      it "can display the result" do
        expect do
          @rule = Brightbox::FirewallRule.find(@rule.id)
        end.to_not raise_error

        display_options = {
          :fields => %i[
            id
            protocol
            source
            sport
            destination
            dport
            icmp_type
            firewall_policy
          ],
          :vertical => true
        }

        output = FauxIO.new do
          Brightbox.render_table([@rule], display_options)
        end

        expect(output.stdout).to include("firewall_policy: #{@policy.id}")
        expect(output.stdout).to include("dport: 1080")
      end
    end
  end
end
