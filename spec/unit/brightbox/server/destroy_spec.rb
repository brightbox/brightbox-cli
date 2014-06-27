require "spec_helper"

describe Brightbox::Server do
  include ServerHelpers

  describe "#destroy" do
    context "when server exists", :vcr do
      it "should work" do
        # FIXME: Spec never actually calls destroy, just checks output of creation!!

        type = Brightbox::Type.find_by_handle "nano"

        options = server_params("wow", type)
        @servers = Brightbox::Server.create_servers 1, options

        output = FauxIO.new do
          Brightbox.render_table(@servers, :vertical => true)
        end
        expect(output.stdout).to include("wow")
        expect(output.stdout).to include("img-12345")
      end
    end
  end
end
