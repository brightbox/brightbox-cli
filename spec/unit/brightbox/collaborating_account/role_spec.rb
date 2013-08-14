require "spec_helper"

describe Brightbox::CollaboratingAccount do
  include_context "collaborating accounts"

  let(:account) { Brightbox::CollaboratingAccount.new(initial_model) }

  describe "#role" do
    context "when account owner" do
      let(:initial_model) { owned_account }

      it "returns 'owner'" do
        expect(account.role).to eql("owner")
      end
    end

    context "when an active account and collaboration" do
      let(:account) { Brightbox::CollaboratingAccount.new(initial_model, active_collaboration) }
      let(:initial_model) { owned_account }

      it "returns 'collaborator'" do
        expect(account.role).to eql("collaborator")
      end
    end

    context "when an active collaboration" do
      let(:initial_model) { active_collaboration }

      it "returns 'collaborator'" do
        expect(account.role).to eql("collaborator")
      end
    end

    context "when an pending collaboration" do
      let(:initial_model) { pending_collaboration }

      it "returns '(invited)'" do
        expect(account.role).to eql("(invited)")
      end
    end
  end
end
