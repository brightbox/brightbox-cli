require "spec_helper"

describe Brightbox::Account do

  describe ".all" do
    context "when connected using an application", :vcr do
      before do
        #pending "Stuck using global configuration (as client)"
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
