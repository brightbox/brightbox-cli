require "spec_helper"

describe Brightbox::FirewallRule do
  before do
    @policy_id = "fwp-30kea"
  end

  describe "#find" do
    use_vcr_cassette("firewall_rule_show")

    before do
      @firewall_rule = Brightbox::FirewallRule.find("fwr-ohc9w")
      @display_options = { :fields => [
          :id, :protocol,:source, :sport,:destination, :dport, :icmp_type, :firewall_policy
        ],
        :vertical => true
      }
    end

    it "should display firewall rule" do
      output = capture_stdout {
        Brightbox.render_table([@firewall_rule],@display_options)
      }
      output.should match(/firewall_policy: fwp-30kea/)
      output.should match(/dport: 22,80,443/)
    end
  end
end
