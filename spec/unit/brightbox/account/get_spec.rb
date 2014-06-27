require "spec_helper"

describe Brightbox::Account do
  before do
    skip "recordings corrupted and no longer working"
  end

  describe ".get" do
    context "when connected using an application" do
      before do
        Brightbox::Api.configuration = USER_APP_CONFIG
      end

      context "and the account is accessible", :vcr do
        before do
          @account_id = "acc-12345"
          @account = Brightbox::Account.get(@account_id)
        end

        it "returns requested account" do
          expect(@account).to be_kind_of(Fog::Compute::Brightbox::Account)
          expect(@account.id).to eql(@account_id)
        end

        it "returns the resource on the same connection" do
          expect(@account.service).to eql(Brightbox::Account.conn)
        end
      end

      context "and the account is unknown", :vcr do
        it "returns nil" do
          expect(Brightbox::Account.get("acc-xxxxx")).to be_nil
        end
      end
    end

    context "when connected using an client", :vcr do
      before do
        Brightbox::Api.configuration = API_CLIENT_CONFIG
      end

      context "and the account is accessible", :vcr do
        before do
          @account_id = "acc-12345"
          @account = Brightbox::Account.get(@account_id)
        end

        it "returns the client's owning account" do
          expect(@account).to be_kind_of(Fog::Compute::Brightbox::Account)
          expect(@account.id).to eql(@account_id)
        end

        it "returns the resource on the same connection" do
          expect(@account.service).to eql(Brightbox::Account.conn)
        end
      end

      context "and the account is unknown", :vcr do
        it "returns nil" do
          expect(Brightbox::Account.get("acc-xxxxx")).to be_nil
        end
      end
    end
  end
end
