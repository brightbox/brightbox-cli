require "spec_helper"

describe Brightbox::Server do
  let(:image_id) { "img-12345" }

  describe "#update" do
    context "when passing new group membership", :vcr do
      before do
        options = {
          :image_id => image_id
        }
        @server = Brightbox::Server.create(options)
        @group = Brightbox::ServerGroup.create({:name => "test"})
      end

      it "should update with group" do
        @server.update(:server_groups => [@group.id])
        @server.reload

        expect(@server.server_groups.size).to eql(1)
        expect(@server.server_groups[0]["id"]).to eq(@group.id)
      end

      after do
        @server.fog_model.wait_for { ready? }
        @server.destroy
      end
    end
  end

end
