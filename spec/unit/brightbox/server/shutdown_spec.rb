require "spec_helper"

describe Brightbox::Server do
  include ServerHelpers

  describe "#shutdown", :vcr do
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_shutdown",type)
      server = (Brightbox::Server.create_servers 1, options).first

      server.fog_model.wait_for { ready? }

      lambda {
        server.shutdown
      }.should_not raise_error
    end
  end
end
