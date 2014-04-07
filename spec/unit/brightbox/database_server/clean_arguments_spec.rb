require "spec_helper"
require "fog/brightbox/models/compute/database_server"

describe Brightbox::DatabaseServer do

  describe ".clean_arguments" do
    let(:parameters) { Brightbox::DatabaseServer.clean_arguments(arguments) }

    context "when no arguments" do
      let(:arguments) { {} }

      it { expect(parameters.keys).to be_empty }
    end

    context "when --allow-access=10.0.0.0" do
      let(:arguments) { { "allow-access" => "10.0.0.0" } }

      it { expect(parameters[:allow_access]).to eql(["10.0.0.0"]) }
    end

    context "when --allow-access=10.0.0.0,11.0.0.0" do
      let(:arguments) { { "allow-access" => "10.0.0.0,11.0.0.0" } }

      it { expect(parameters[:allow_access]).to eql(%w(10.0.0.0 11.0.0.0)) }
    end

    context "when --maintenance-weekday=4" do
      let(:arguments) { { "maintenance-weekday" => "4" } }

      it { expect(parameters[:maintenance_weekday]).to eql("4") }
    end

    context "when --maintenance-weekday=wednesday" do
      let(:arguments) { { "maintenance-weekday" => "3" } }

      it { expect(parameters[:maintenance_weekday]).to eql("3") }
    end

    context "when --maintenance-weekday=" do
      let(:arguments) { { "maintenance-weekday" => "" } }

      it { expect(parameters[:maintenance_weekday]).to be_nil }
    end

    context "when --default-maintenance" do
      let(:arguments) { { "default-maintenance" => "" } }

      it { expect(parameters[:maintenance_weekday]).to be_nil }
      it { expect(parameters[:maintenance_hour]).to be_nil }
    end
  end
end
