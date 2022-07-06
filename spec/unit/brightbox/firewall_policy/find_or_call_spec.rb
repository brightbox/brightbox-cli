require "spec_helper"

describe Brightbox::FirewallPolicy do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#find_or_call" do
    context "when a policy exists" do
      before do
        options = {
        }
        @policy = Brightbox::FirewallPolicy.create(options)
      end

      it "should show firewall policy", vcr: true do
        output = FauxIO.new do
          firewall_policy = Brightbox::FirewallPolicy.find_or_call([@policy.id])
          Brightbox.render_table(firewall_policy, :vertical => true)
        end
        expect(output.stdout).to include(@policy.id)
      end

      after do
        @policy.destroy
      end
    end
  end
end
