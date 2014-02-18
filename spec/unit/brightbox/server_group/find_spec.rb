require "spec_helper"

describe Brightbox::ServerGroup do

  describe "#find(:all)" do
    context "when a group exists", :vcr do
      before do
        options = {
          :name => "Test group"
        }
        @group = Brightbox::ServerGroup.create(options)
      end

      it "list server groups" do
        server_groups = Brightbox::ServerGroup.find(:all)
        output = FauxIO.new do
          Brightbox.render_table(server_groups,{})
        end
        expect(output.stdout).to include(@group.id)
      end

      after do
        @group.destroy
      end
    end
  end
end
