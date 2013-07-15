require "spec_helper"

describe Brightbox::Server do

  describe "#create" do
    context "when account limit reached" do
      it "should print error if account limit reached" do
        options = {
          :image_id => "img-4gqhs", :name => "medium servers",
          :zone_id => "", :user_data => nil, :flavor_id => "typ-qdiwq"
        }
        Brightbox::Server.expects(:create).raises(limit_exceeded_exception)
        error = nil
        begin
          Brightbox::Server.create(options)
        rescue Exception => e
          error = Brightbox::ErrorParser.new(e)
        end
        output = capture_stderr { error.pretty_print() }
        output.should match(/Account limit reached, please contact support for more information/i)
      end
    end
  end
end
