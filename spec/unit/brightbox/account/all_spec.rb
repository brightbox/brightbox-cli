require "spec_helper"

describe Brightbox::Account do
  before do
    Brightbox.config = config_from_contents(contents)
  end

  describe ".all" do
    context "when connected using an application", vcr: true do
      let(:contents) { USER_APP_CONFIG_CONTENTS }

      it "returns a collection of Accounts" do
        expect(Brightbox::Account.all).to be_kind_of(Array)

        Brightbox::Account.all.each do |account|
          expect(account).to be_kind_of(Fog::Brightbox::Compute::Account)
        end
      end

      it "returns resources on the same connection" do
        Brightbox::Account.all.each do |account|
          expect(account.service).to eql(Brightbox::Account.conn)
        end
      end
    end

    context "when connected using an client", vcr: true do
      let(:contents) { API_CLIENT_CONFIG_CONTENTS }

      it "returns a collection of Accounts" do
        expect(Brightbox::Account.all).to be_kind_of(Array)

        Brightbox::Account.all.each do |account|
          expect(account).to be_kind_of(Fog::Brightbox::Compute::Account)
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
