require "spec_helper"

require "time"

describe Time do

  describe "#clipped_iso_8601" do
    it "returns a shortened version of the ISO8601 datetime" do
      expect(Time.now.clipped_iso_8601).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}\z/)
    end
  end

  describe "#to_s" do
    it "returns the clipped ISO 8601 time" do
      the_time = Time.now
      expect(the_time.to_s).to eql(the_time.clipped_iso_8601)
    end
  end
end
