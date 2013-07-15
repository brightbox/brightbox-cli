require "spec_helper"

describe Brightbox::Api, "#fog_model" do

  context "when initialised with a fog model" do
    before do
      @identifier = "api-12345"
      @fog_model = mock
      expect(@fog_model).to receive(:id).and_return(@identifier)
      allow(@fog_model).to receive(:attributes).and_return({})
    end

    it "returns the object" do
      @api_instance = Brightbox::Api.new(@fog_model)
      expect(@api_instance.fog_model).to eql(@fog_model)
    end
  end

  context "when initialised with an identifier string" do
    it "attempts to find a resource" do
      @identifier = "api-12345"
      @fog_model = mock

      @api_instance = Brightbox::Api.new(@identifier)
      expect(Brightbox::Api).to receive(:find).with(@identifier).and_return(@fog_model)
      expect(@api_instance.fog_model).to eql(@fog_model)
    end
  end
end
