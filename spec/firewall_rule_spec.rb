require "spec_helper"

describe "FirewallRule" do
  before do
    @policy_id = "fwp-30kea"
  end

  describe "creating firewall rule" do
    use_vcr_cassette('firewall_rule_create')
    before do
      create_options = {}
      create_options[:destination] = "0.0.0.0/0"
      create_options[:destination_port] = "1080"
      create_options[:protocol] = "tcp"
      create_options[:firewall_policy_id] = @policy_id
      @firewall_rule = Brightbox::FirewallRule.create(create_options)
    end

    it "should create the rule successfully" do
      output = capture_stdout {
        Brightbox.render_table([@firewall_rule],{:vertical => true})
      }
      output.should match(/1080/)
      output.should match(/fwr-/)
      output.should match(/(0\.){3}/)
    end
  end

  describe "Listing firewall rule for a policy" do
    use_vcr_cassette('firewall_rule_list')
    before do
      @firewall_policy = Brightbox::FirewallPolicy.find(@policy_id)
      @firewall_rules = Brightbox::FirewallRules.from_policy(@firewall_policy)
    end
    it "should list all rules" do
      output = capture_stdout {
        Brightbox.render_table(@firewall_rules,:vertical => true)
      }
      output.should match(/1080/)
    end
  end

  describe "Destroying firewall rule for a policy" do

  end
end
