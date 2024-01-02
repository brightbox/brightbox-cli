require "spec_helper"

describe Brightbox::Server do
  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#show", vcr: true do
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
        output = FauxIO.new do
          Brightbox.render_table(@servers, :vertical => true)
        end
        expect(output.stdout).to include("private_ips:")
        expect(output.stdout).to include("ram:")
        expect(output.stdout).to include("disk:")
        expect(output.stdout).to include("hostname: #{@server.id}")
        expect(output.stdout).to include("ipv6_hostname: ipv6.#{@server.id}.gb1.brightbox.com")
        expect(output.stdout).to include("fqdn: #{@server.id}.gb1.brightbox.com")

        expect(output.stdout).to include("image: img-12345")
        expect(output.stdout).to include("image_username: ubuntu")
      end
    end
  end
end
