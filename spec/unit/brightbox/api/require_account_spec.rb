require "spec_helper"

describe Brightbox::Api, ".require_account?" do

  context "when on abstract class" do
    it "returns false" do
      expect(Brightbox::Api.require_account?).to be false
    end
  end
end
