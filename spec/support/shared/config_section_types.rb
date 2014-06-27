shared_examples "a config section type" do
  it { is_expected.to respond_to(:to_fog) }
  it { is_expected.to respond_to(:valid?) }
end
