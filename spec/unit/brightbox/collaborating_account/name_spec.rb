require "spec_helper"

describe Brightbox::CollaboratingAccount do
  include_context "collaborating accounts"

  let(:account) { Brightbox::CollaboratingAccount.new(initial_model) }

  describe "#name" do
    context "when initialised with an account" do
      let(:initial_model) { owned_account }

      it "returns account's name" do
        expect(account.name).to eql("Owned account name")
      end
    end

    context "when initialised with a collaboration" do
      let(:initial_model) { active_collaboration }

      it "returns nested account's name" do
        expect(account.name).to eql("Active collaboration name")
      end
    end
  end
end
