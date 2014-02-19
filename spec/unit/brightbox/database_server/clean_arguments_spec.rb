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
  end
end
