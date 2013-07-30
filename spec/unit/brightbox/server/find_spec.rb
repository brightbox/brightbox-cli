require "spec_helper"

describe Brightbox::Server do
  let(:image_id) { "img-12345" }

  describe "#find(:all)" do
    context "when a server exists", :vcr do
      before do
        options = {
          :image_id => image_id
        }
        @server = Brightbox::Server.create(options)
      end

      it "should print server list" do
        @servers = Brightbox::Server.find(:all)

        output = FauxIO.new do
          Brightbox.render_table(@servers, {})
        end
        expect(output.stdout).to include(@server.id)
      end

      after do
        @server.fog_model.wait_for { ready? }
        @server.destroy
      end
    end
  end
end
