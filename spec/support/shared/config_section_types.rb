shared_examples "a config section type" do
  it { should respond_to(:to_fog) }
  it { should respond_to(:valid?) }
end
