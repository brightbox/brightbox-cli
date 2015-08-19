require "spec_helper"

describe Brightbox::FirewallRule do

  describe "#create" do
    context "when policy exists" do
      before do
        policy_options = {
        }
        @policy = Brightbox::FirewallPolicy.create(policy_options)

        @rule_options = {
          :destination => "0.0.0.0/0",
          :destination_port => "1080",
          :protocol => "tcp",
          :firewall_policy_id => @policy.id
        }
      end

      it "creates the rule successfully", vcr: true do
        @rule = Brightbox::FirewallRule.create(@rule_options)
        output = FauxIO.new do
          Brightbox.render_table([@rule], :vertical => true)
        end

        expect(output.stdout).to include(@rule.id)
      end

      after do
        @rule.destroy
        @policy.destroy
      end
    end
  end
end
