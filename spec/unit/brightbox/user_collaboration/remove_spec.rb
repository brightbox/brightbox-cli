require "spec_helper"

describe Brightbox::UserCollaboration do

  describe "#remove" do
    context "when collaboration is pending" do
      it "tells model to reject collaboration" do
        data = faux_collaboration_data("pending")
        collaboration = Brightbox::UserCollaboration.new(data)
        expect(collaboration).to receive(:reject)
        collaboration.remove
      end
    end

    context "when collaboration is accepted" do
      it "tells model to destroy collaboration" do
        data = faux_collaboration_data("accepted")
        collaboration = Brightbox::UserCollaboration.new(data)
        expect(collaboration).to receive(:destroy)
        collaboration.remove
      end
    end
  end

  # Returns a fog model of a UserCollaboration to initialise a CLI model
  #
  def faux_collaboration_data(status, options = {})
    api_response_data = {
      "id" => "col-12345",
      "resource_type" => "collaboration",
      "url" => "https://api.gb1.brightbox.com/1.0/user/collaborations/col-12345",
      "status" => status,
      "email" => "invitee@example.com",
      "role" => "admin",
      "created_at" => "2013-08-13T11:59:24Z",
      "started_at" => nil,
      "finished_at" => "2013-08-13T13:21:58Z",
      "role_label" => "Collaborator",
      "user" => nil,
      "account" => {
        "id" => "acc-12345",
        "resource_type"=>"account",
        "url"=>"https://api.gb1.brightbox.com/1.0/accounts/acc-12345",
        "name"=>"System account",
        "status"=>"active"
      },
      "inviter"=>{
        "id"=>"usr-54321",
        "resource_type"=>"user",
        "url"=>"https://api.gb1.brightbox.com/1.0/users/usr-54321",
        "name"=>"Marie Halvorson",
        "email_address"=>"marie@example.com"
      }
    }
    Fog::Compute::Brightbox::UserCollaboration.new(api_response_data)
  end
end
