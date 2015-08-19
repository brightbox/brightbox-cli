require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#find(:all)", vcr: true do

    context "when a policy exists" do
      before do
        options = {}
        @policy = Brightbox::FirewallPolicy.create(options)
      end

      it "should list firewall policy", vcr: true do
        output = FauxIO.new do
          firewall_policies = Brightbox::FirewallPolicy.find(:all)
          Brightbox.render_table(firewall_policies, :vertical => true)
        end

        expect(output.stdout).to include(@policy.id)
      end

      after do
        @policy.destroy
      end
    end
  end
end
