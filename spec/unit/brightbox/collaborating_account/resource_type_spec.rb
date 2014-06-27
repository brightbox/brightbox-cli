require "spec_helper"

describe Brightbox::CollaboratingAccount do
  include_context "collaborating accounts"

  let(:account) { Brightbox::CollaboratingAccount.new(initial_model) }

  describe "#resource_type" do
    context "when initialised with an Account" do
      let(:initial_model) { owned_account }

      it "returns 'account'" do
        expect(account.resource_type).to eql("account")
      end
    end

    context "when initialised with a User Collaboration" do
      let(:initial_model) { active_collaboration }

      it "returns 'collaboration'" do
        expect(account.resource_type).to eql("collaboration")
      end
    end
  end

  describe "#account?" do
    context "when initialised with an Account" do
      let(:initial_model) { owned_account }

      it "returns true" do
        expect(account.account?).to be true
      end
    end

    context "when initialised with a User Collaboration" do
      let(:initial_model) { active_collaboration }

      it "returns false'" do
        expect(account.account?).to be false
      end
    end
  end

  describe "#collaboration?" do
    context "when initialised with an Account" do
      let(:initial_model) { owned_account }

      it "returns false" do
        expect(account.collaboration?).to be false
      end
    end

    context "when initialised with a User Collaboration" do
      let(:initial_model) { active_collaboration }

      it "returns true'" do
        expect(account.collaboration?).to be true
      end
    end
  end
end
