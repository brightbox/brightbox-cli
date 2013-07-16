require "spec_helper"

describe Brightbox::Server do
  include ServerHelpers

  describe "#start", :vcr do
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_start",type)
      server = (Brightbox::Server.create_servers 1, options).first

      server.fog_model.wait_for { ready? }

      lambda {
        server.stop
        server.fog_model.wait_for { ! ready? }

        server.start
      }.should_not raise_error
    end
  end
end
