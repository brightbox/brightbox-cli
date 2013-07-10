require "spec_helper"

describe Brightbox::Api, "#fog_model" do

  context "when initialised with a fog model" do
    before do
      @identifier = "api-12345"
      @fog_model = mock
      @fog_model.expects(:id).returns(@identifier)
      @fog_model.stubs(:attributes).returns({})
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
      Brightbox::Api.expects(:find).with(@identifier).returns(@fog_model)
      expect(@api_instance.fog_model).to eql(@fog_model)
    end
  end
end
