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
end
