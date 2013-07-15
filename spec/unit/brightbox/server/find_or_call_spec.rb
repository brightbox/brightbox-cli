require "spec_helper"

describe Brightbox::Server do

  describe "Server show" do
    use_vcr_cassette('server_show')

    before do
      @servers = Brightbox::DetailedServer.find_or_call(["srv-egjzh"])
    end

    it "should show detailed attributes of a server" do
      output = capture_stdout {
        Brightbox.render_table(@servers,{:vertical => true})
      }
      output.should match("10.250.188.238")
      output.should match(/ram: 512/)
      output.should match(/disk: 20480/)
      output.should match(/public_hostname: public.srv-egjzh.gb1s.brightbox.com/)
      output.should match(/fqdn: srv-egjzh.gb1s.brightbox.com/)
    end
  end
end
