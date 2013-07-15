require "spec_helper"

describe Brightbox::FirewallPolicy do

  describe "#destroy" do
    use_vcr_cassette('destroy_firewall_policy')

    it "should destroy firewall policy" do
      params = { :name => "rspec_tests"}
      @group = Brightbox::ServerGroup.create(params)
      lambda do
        firewall_options = {
          :name => "rspec_firewall_policy",
          :server_group_id => @group.id
        }
        @firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
        @firewall_policy.destroy
      end.should_not raise_error
      @group.destroy()
    end
  end
end
