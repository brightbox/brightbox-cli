require "spec_helper"

describe Brightbox::Api, ".conn" do

  context "when account is not required", vcr: true do
    it "returns a 'real' fog compute instance" do
      expect(Brightbox::Api.conn).to be_instance_of(Fog::Compute::Brightbox::Real)
    end
  end
end
