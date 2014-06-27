require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#create", :vcr do

    it "should create firewall policy" do
      params = { :name => "rspec_tests"}
      @group = Brightbox::ServerGroup.create(params)
      expect do
        firewall_options = {
          :name => "rspec_firewall_policy",
          :server_group_id => @group.id
        }
        @firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
      end.not_to raise_error

      output = FauxIO.new do
        Brightbox.render_table([@firewall_policy],:vertical => true)
      end

      expect(output.stdout).to match(/rspec_firewall_policy/)
      @group.destroy()
    end
  end
end
