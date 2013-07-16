require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#find(:all)", :vcr do

    context "when a policy exists" do
      before do
        options = {}
        @policy = Brightbox::FirewallPolicy.create(options)
      end

      it "should list firewall policy", :vcr do
        output = capture_stdout {
          firewall_policies = Brightbox::FirewallPolicy.find(:all)
          Brightbox.render_table(firewall_policies,:vertical => true)
        }

        expect(output).to include(@policy.id)
      end

      after do
        @policy.destroy
      end
    end
  end
end
