require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe Brightbox::DatabaseServer, "#cloud_ips" do
  let(:fog_model) { Fog::Compute::Brightbox::DatabaseServer.new(fog_settings) }
  let(:dbs) { described_class.new(fog_model) }

  context "when attribute is missing" do
    let(:fog_settings) { {} }
    it { expect(dbs.cloud_ips).to be_empty }
  end

  context "when attribute is empty" do
    let(:fog_settings) { { cloud_ips: [] } }
    it { expect(dbs.cloud_ips).to be_empty }
  end

  context "when attribute contains data" do
    let(:cloud_ip) { { id: "cip-12345", public_ip: "10.0.0.10" } }
    let(:fog_settings) { { cloud_ips: [cloud_ip] } }
    it { expect(dbs.cloud_ips).to include(cloud_ip) }
  end
end
