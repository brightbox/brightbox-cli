require "spec_helper"

describe Brightbox::Server do

  describe "#show", :vcr do
    context "when server exists" do
      before do
        options = {
          :image_id => "img-12345",
          :name => "medium servers",
          :zone_id => "",
          :user_data => nil,
          :flavor_id => "typ-12345"
        }
        @server = Brightbox::Server.create options
        @servers = Brightbox::DetailedServer.find_or_call([@server.id])
      end

      it "shows detailed attributes of a server" do
        output = capture_stdout {
          Brightbox.render_table(@servers, {:vertical => true})
        }
        output.should include("private_ips:")
        output.should include("ram:")
        output.should include("disk:")
        output.should include("hostname: #{@server.id}")
        output.should include("ipv6_hostname: ipv6.#{@server.id}.gb1.brightbox.com")
        output.should include("fqdn: #{@server.id}.gb1.brightbox.com")
      end
    end
  end
end
