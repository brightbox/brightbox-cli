require "spec_helper"

describe Brightbox::FirewallPolicy do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#apply_to", vcr: true do

    it "should apply firewall policy" do
      expect do
        params = { :name => "rspec_tests_apply" }
        group = Brightbox::ServerGroup.create(params)
        firewall_options = {
          :name => "rspec_firewall_policy_apply"
        }
        firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
        firewall_policy.apply_to(group.id)
        group.destroy
      end.not_to raise_error
    end
  end
end
