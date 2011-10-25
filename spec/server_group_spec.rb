require "spec_helper"

describe "Server Group" do
  describe "listing server groups" do
    use_vcr_cassette('list_server_groups')

    it "should list server groups" do
      server_groups = Brightbox::ServerGroup.find(:all)
      output = capture_stdout {
        Brightbox.render_table(server_groups,{})
      }
      output.should match(/8/)
    end
  end
end
