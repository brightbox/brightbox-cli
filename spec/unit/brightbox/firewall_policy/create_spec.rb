require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#create", :vcr do

    it "should create firewall policy" do
      params = { :name => "rspec_tests"}
      @group = Brightbox::ServerGroup.create(params)
      lambda do
        firewall_options = {
          :name => "rspec_firewall_policy",
          :server_group_id => @group.id
        }
        @firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
      end.should_not raise_error
      output = capture_stdout {
        Brightbox.render_table([@firewall_policy],:vertical => true)
      }
      output.should match(/rspec_firewall_policy/)
      @group.destroy()
    end
  end
end
