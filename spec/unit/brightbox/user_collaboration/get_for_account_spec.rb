require "spec_helper"

describe Brightbox::UserCollaboration do

  describe ".get_for_account" do
    before do
      # Until VCR recording can be sorted, we mock at the fog level
      expect(Brightbox::UserCollaboration.conn).to receive(:user_collaborations).and_return(faux_api_response)
    end

    context "when collaboration exists but is complete", :vcr do
      it "does not return the complete collaboration" do
        @account = "acc-aaaaa"
        @collaboration = Brightbox::UserCollaboration.get_for_account(@account)
        expect(@collaboration.id).to_not eql("col-aaaaa")
      end
    end

    context "when a collaboration exists for user on account", :vcr do
      before do
        @account = "acc-aaaaa"
        @collaboration = Brightbox::UserCollaboration.get_for_account(@account)
      end

      it "returns the open collaboration" do
        expect(@collaboration.id).to eql("col-bbbbb")
      end

      it "returns a user collaboration" do
        expect(@collaboration).to be_kind_of(Brightbox::UserCollaboration)
      end
    end

    context "when multiple collaborations exist", :vcr do
      before do
        @account = "acc-aaaaa"
        @collaboration = Brightbox::UserCollaboration.get_for_account(@account)
      end

      it "returns the open one" do
        expect(@collaboration.id).to eql("col-bbbbb")
      end
    end

    context "when no collaboration exists", :vcr do
      it "returns nil" do
        @account = "acc-zzzzz"
        @collaboration = Brightbox::UserCollaboration.get_for_account(@account)
        expect(@collaboration).to be_nil
      end
    end

    # A collection of fog models
    def faux_api_response
      api_response_data = [
        {
          "id" => "col-aaaaa",
          "resource_type" => "collaboration",
          "url" => "https://api.gb1.brightbox.com/1.0/user/collaborations/col-aaaaa",
          "status" => "rejected",
          "email" => "invitee@example.com",
          "role" => "admin",
          "created_at" => "2013-08-13T11:59:24Z",
          "started_at" => nil,
          "finished_at" => "2013-08-13T13:21:58Z",
          "role_label" => "Collaborator",
          "user" => nil,
          "account" => {
            "id" => "acc-aaaaa",
            "resource_type" => "account",
            "url" => "https://api.gb1.brightbox.com/1.0/accounts/acc-aaaaa",
            "name" => "System account",
            "status" => "active"
          },
          "inviter" => {
            "id" => "usr-54321",
            "resource_type" => "user",
            "url" => "https://api.gb1.brightbox.com/1.0/users/usr-54321",
            "name" => "Marie Halvorson",
            "email_address" => "marie@example.com"
          }
        },
        {
          "id" => "col-bbbbb",
          "resource_type" => "collaboration",
          "url" => "https://api.gb1.brightbox.com/1.0/user/collaborations/col-bbbbb",
          "status" => "pending",
          "email" => "invitee@example.com",
          "role" => "admin",
          "created_at" => "2013-08-13T11:59:24Z",
          "started_at" => nil,
          "finished_at" => nil,
          "role_label" => "Collaborator",
          "user" => nil,
          "account" => {
            "id" => "acc-aaaaa",
            "resource_type" => "account",
            "url" => "https://api.gb1.brightbox.com/1.0/accounts/acc-aaaaa",
            "name" => "System account",
            "status" => "active"
          },
          "inviter" => {
            "id" => "usr-54321",
            "resource_type" => "user",
            "url" => "https://api.gb1.brightbox.com/1.0/users/usr-54321",
            "name" => "Marie Halvorson",
            "email_address" => "marie@example.com"
          }
        },
        {
          "id" => "col-ccccc",
          "resource_type" => "collaboration",
          "url" => "https://api.gb1.brightbox.com/1.0/user/collaborations/col-ccccc",
          "status" => "pending",
          "email" => "invitee@example.com",
          "role" => "admin",
          "created_at" => "2013-08-13T11:59:24Z",
          "started_at" => nil,
          "finished_at" => nil,
          "role_label" => "Collaborator",
          "user" => nil,
          "account" => {
            "id" => "acc-bbbbb",
            "resource_type" => "account",
            "url" => "https://api.gb1.brightbox.com/1.0/accounts/acc-bbbbb",
            "name" => "System account",
            "status" => "active"
          },
          "inviter" => {
            "id" => "usr-54321",
            "resource_type" => "user",
            "url" => "https://api.gb1.brightbox.com/1.0/users/usr-54321",
            "name" => "Marie Halvorson",
            "email_address" => "marie@example.com"
          }
        }
      ]
      # Collection#load is private in fog so we can't just pass our collection
      # into get the correct object initialised.
      api_response_data.map do |datum|
        Fog::Compute::Brightbox::UserCollaboration.new(datum)
      end
    end
  end
end
