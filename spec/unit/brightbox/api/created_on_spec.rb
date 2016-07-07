require "spec_helper"

describe Brightbox::Api, "#created_on" do
  subject(:api_model) { described_class.new(fog_model) }
  let(:fog_model) do
    double id: nil,
          attributes: attrs,
          created_at: attrs[:created_at]
  end

  context "when initialised with no attributes" do
    let(:attrs) { {} }

    it { expect(api_model.created_on).to be_nil }
  end

  context "when initialised with created_at" do
    let(:attrs) { { created_at: Time.utc(2016, 7, 7, 12, 34, 56) } }

    it { expect(api_model.created_on).to eq("2016-07-07") }
  end
end
