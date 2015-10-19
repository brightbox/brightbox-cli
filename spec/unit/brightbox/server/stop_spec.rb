require "spec_helper"

describe Brightbox::Server do
  include ServerHelpers

  before do
    config_from_contents(API_CLIENT_CONFIG_CONTENTS)
  end

  describe "#stop", vcr: true do
    it "should work" do
      type = Brightbox::Type.find_by_handle "nano"
      options = server_params("rspec_server_stop", type)
      server = (Brightbox::Server.create_servers 1, options).first

      server.fog_model.wait_for { ready? }

      expect { server.stop }.not_to raise_error
    end
  end
end
