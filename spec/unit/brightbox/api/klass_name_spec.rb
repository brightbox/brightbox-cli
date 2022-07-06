require "spec_helper"

describe Brightbox::Api, ".klass_name" do
  context "when called on abstract class" do
    it "returns 'Api' as string" do
      expect(Brightbox::Api.klass_name).to eq("Api")
    end
  end
end
