require "spec_helper"

describe Brightbox::Api, ".find" do

  context "when passed nil" do
    it "raises an error" do
      expect {
        Brightbox::Api.find(nil)
      }.to raise_error(Brightbox::Api::InvalidArguments)
    end
  end

  context "when passed an empty object" do
    it "raises an error" do
      expect {
        Brightbox::Api.find([])
      }.to raise_error(Brightbox::Api::InvalidArguments)
    end
  end

  context "when all objects are requested" do
    it "returns a collection" do
      @fog_model = mock
      @resource = mock
      expect(Brightbox::Api).to receive(:all).and_return([@fog_model])
      expect(Brightbox::Api).to receive(:new).with(@fog_model).and_return(@resource)
      expect(Brightbox::Api.find(:all)).to eql([@resource])
    end
  end

  context "when passed an identifier string" do
    it "returns a wrapped Api model" do
      @identifier = "api-12345"
      @fog_model = mock
      @resource = mock
      expect(Brightbox::Api).to receive(:get).with(@identifier).and_return(@fog_model)
      expect(Brightbox::Api).to receive(:new).with(@fog_model).and_return(@resource)
      expect(Brightbox::Api.find(@identifier)).to eql(@resource)
    end
  end

  context "when passed a collection of identifiers" do
    before do
      @identifier = "api-12345"
      @fog_model = mock
      @resource = mock
    end

    it "returns collection of found resources" do
      expect(Brightbox::Api).to receive(:cached_get).with(@identifier).and_return(@fog_model)
      expect(Brightbox::Api).to receive(:new).with(@fog_model).and_return(@resource)
      expect(Brightbox::Api.find([@identifier])).to eq([@resource])
    end
  end

  context "when passed a bad search value" do
    it "raises an error" do
      expect {
        Brightbox::Api.find(mock)
      }.to raise_error(Brightbox::Api::InvalidArguments)
    end
  end
end
