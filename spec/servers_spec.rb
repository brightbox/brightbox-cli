require "spec_helper"


describe "Server" do
  describe "server listing" do
    use_vcr_cassette('server_list')
    before(:each) do
      @servers = Brightbox::Server.find(:all)
    end

    it "should print server list" do
      output = capture_stdout { 
        Brightbox.render_table(@servers, {})
      }
      output.should match(/active/)
    end
  end
end
