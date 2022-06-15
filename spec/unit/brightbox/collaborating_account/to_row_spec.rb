require "spec_helper"

describe Brightbox::CollaboratingAccount do
  include_context "collaborating accounts"

  let(:account) { Brightbox::CollaboratingAccount.new(initial_model) }
  let(:row_data) { account.to_row }

  describe "#to_row" do
    context "when initialised with an account" do
      let(:initial_model) { owned_account }

      [:cloud_ips_limit, :lb_limit, :ram_limit, :ram_used, :ram_free].each do |key|
        it "returns the number for #{key}" do
          expect(row_data[key]).to be_kind_of(Integer)
        end
      end
    end

    context "when initialised with a collaboration" do
      let(:initial_model) { active_collaboration }

      [:cloud_ips_limit, :lb_limit, :ram_limit, :ram_used, :ram_free].each do |key|
        it "returns empty string for #{key}" do
          expect(row_data[key]).to eql("")
        end
      end
    end
  end
end
