require "spec_helper"

describe Brightbox::Account do
  before do
    pending "recordings corrupted and no longer working"
  end

  describe ".all" do
    context "when connected using an application", :vcr do
      before do
        Brightbox::Api.configuration = USER_APP_CONFIG
      end

      it "returns a collection of Accounts" do
        expect(Brightbox::Account.all).to be_kind_of(Array)

        Brightbox::Account.all.each do |account|
          expect(account).to be_kind_of(Fog::Compute::Brightbox::Account)
        end
      end

      it "returns resources on the same connection" do
        Brightbox::Account.all.each do |account|
          expect(account.service).to eql(Brightbox::Account.conn)
        end
      end
    end

    context "when connected using an client", :vcr do
      before do
        Brightbox::Api.configuration = API_CLIENT_CONFIG
      end

      it "returns a collection of Accounts" do
        expect(Brightbox::Account.all).to be_kind_of(Array)

        Brightbox::Account.all.each do |account|
          expect(account).to be_kind_of(Fog::Compute::Brightbox::Account)
        end
      end

      it "returns resources on the same connection" do
        Brightbox::Account.all.each do |account|
          expect(account.service).to eql(Brightbox::Account.conn)
        end
      end
    end
  end
end
