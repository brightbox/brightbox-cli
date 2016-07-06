require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe Brightbox::DatabaseServer do

  describe "#maintenance_window" do
    let(:fog_model) { Fog::Compute::Brightbox::DatabaseServer.new(fog_settings) }
    let(:dbs) { Brightbox::DatabaseServer.new(fog_model) }

    context "when default values" do
      let(:fog_settings) do
        {
          "maintenance_weekday" => 0,
          "maintenance_hour" => 6
        }
      end

      it "returns 'Sunday 06:00 UTC'" do
        expect(dbs.maintenance_window).to eql("Sunday 06:00 UTC")
      end
    end

    context "when non standard values" do
      let(:fog_settings) do
        {
          "maintenance_weekday" => 6,
          "maintenance_hour" => 23
        }
      end

      it "returns 'Saturday 23:00 UTC'" do
        expect(dbs.maintenance_window).to eql("Saturday 23:00 UTC")
      end
    end

    context "when not initialised" do
      let(:fog_settings) { {} }

      it "returns nil" do
        expect(dbs.maintenance_window).to be_nil
      end
    end
  end
end
