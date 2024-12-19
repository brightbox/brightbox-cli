shared_examples "a wrapped API resource" do
  it { expect(described_class).to respond_to(:require_account?) }
  it { expect(described_class).to respond_to(:klass_name) }
  it { expect(described_class).to respond_to(:get) }
  it { expect(described_class).to respond_to(:find) }

  it { is_expected.to respond_to(:fog_model) }
  it { is_expected.to respond_to(:exists?) }
  it { is_expected.to respond_to(:to_row) }

  it { is_expected.to respond_to(:to_s) }

  it "#to_s equals the #id" do
    expect(subject.to_s).to eql(subject.id)
  end

  # describe "#attributes" do
  #   subject { described_class.new(fog_model) }

  #   let(:fog_model) do
  #     double("Fog::Model", id: "res-12345", attributes: { id: "res-12345"})
  #   end

  #   it "returns an IndifferentAccessHash" do
  #     expect(subject.attributes).to be_a(IndifferentAccessHash)
  #   end
  # end

  # describe "#to_row" do
  #   subject { described_class.new(fog_model) }

  #   let(:fog_model) do
  #     double("Fog::Model", id: "res-12345", attributes: { id: "res-12345"})
  #   end

  #   it "returns a Hash to avoid hirb errors" do
  #     expect(subject.to_row).to be_a(Hash)
  #   end
  # end
end
