require "spec_helper"

describe Brightbox::FirewallPolicy do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#destroy", vcr: true do
    it "should destroy firewall policy" do
      params = { :name => "rspec_tests" }
      @group = Brightbox::ServerGroup.create(params)
      expect do
        firewall_options = {
          :name => "rspec_firewall_policy",
          :server_group_id => @group.id
        }
        @firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
        @firewall_policy.destroy
      end.not_to raise_error
      @group.destroy
    end
  end
end
