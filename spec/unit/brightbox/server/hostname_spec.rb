require "spec_helper"
require "fog/brightbox/models/compute/server"

RSpec.describe Brightbox::Server, "#hostname" do
  let(:fog_model) { Fog::Brightbox::Compute::Server.new(fog_settings) }
  let(:server) { described_class.new(fog_model) }

  context "when hostname is not equal to id" do
    let(:fog_settings) do
      {
        id: "srv-12345",
        cloud_ips: [],
        hostname: "server-hostname",
        image_id: "img-12345",
        interfaces: [],
        server_type: "typ-12345"
      }
    end

    it "returns the hostname" do
      expect(server.attributes[:id]).to eq("srv-12345")
      expect(server.attributes[:hostname]).to eq("server-hostname")

      expect(server.hostname).to eq("server-hostname")
    end
  end
end
