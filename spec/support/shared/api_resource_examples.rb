shared_examples "a wrapped API resource" do
  it { described_class.should respond_to(:require_account?) }
  it { described_class.should respond_to(:klass_name) }
  it { described_class.should respond_to(:get) }
  it { described_class.should respond_to(:find) }

  it { should respond_to(:fog_model) }
  it { should respond_to(:exists?) }
  it { should respond_to(:to_row) }

  it { should respond_to(:to_s) }
  it "#to_s equals the #id" do
    expect(subject.to_s).to eql(subject.id)
  end
end
