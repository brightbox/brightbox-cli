require "spec_helper"

describe Brightbox::Api, "#fog_model" do
  let(:fog_model) { Fog::Model.new }
  let(:identifier) { "api-12345" }

  before do
    allow(fog_model).to receive(:id).and_return(identifier)
    allow(fog_model).to receive(:attributes).and_return({})
  end

  context "when initialised with a fog model" do
    subject(:instance) { described_class.new(fog_model) }

    it "returns the object" do
      expect(instance.fog_model).to eql(fog_model)
    end
  end

  context "when initialised with an identifier string" do
    subject(:instance) { described_class.new(identifier) }

    it "attempts to find a resource" do
      expect(Brightbox::Api).to receive(:find).with(identifier).and_return(fog_model)

      expect(instance.fog_model).to eql(fog_model)
    end
  end
end
