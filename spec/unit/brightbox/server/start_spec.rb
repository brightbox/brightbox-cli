require "spec_helper"

describe Brightbox::Server do
  include ServerHelpers

  describe "#start", :vcr do
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_start",type)
      server = (Brightbox::Server.create_servers 1, options).first

      server.fog_model.wait_for { ready? }

      expect {
        server.stop
        server.fog_model.wait_for { ! ready? }

        server.start
      }.not_to raise_error
    end
  end
end
