require "spec_helper"

describe "Firewall Policy" do
  describe "Creating firewall policy" do
    use_vcr_cassette('create_firewall_policy')
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

  describe "Destroying firewall policy" do
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

  describe "Listing firewall policy" do
    use_vcr_cassette('list_firewall_policy')
    it "should list firewall policy" do
      output = capture_stdout {
        firewall_policies = Brightbox::FirewallPolicy.find(:all)
        Brightbox.render_table(firewall_policies,:vertical => true)
      }
      output.should match(/default_permissive_policy/)
    end
  end

  describe "Displaying one firewall policy" do
    use_vcr_cassette('show_firewall_policy')
    it "should show firewall policy" do
      output = capture_stdout {
        firewall_policy = Brightbox::FirewallPolicy.find_or_call(["fwp-3q9jp"])
        Brightbox.render_table(firewall_policy,:vertical => true)
      }
      output.should match(/default_permissive_policy/)
    end
  end

  describe "apply firewall policy" do
    use_vcr_cassette('apply_firewall_policy')
    it "should apply firewall policy" do
      lambda {
        params = { :name => "rspec_tests_apply"}
        group = Brightbox::ServerGroup.create(params)
        firewall_options = {
          :name => "rspec_firewall_policy_apply"
        }
        firewall_policy = Brightbox::FirewallPolicy.create(firewall_options)
        firewall_policy.apply_to(group.id)
        group.destroy
      }.should_not raise_error
    end
  end
end
