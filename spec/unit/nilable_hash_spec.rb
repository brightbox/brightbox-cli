require "spec_helper"

describe NilableHash, "#nilify_blanks" do
  before do
    @blank_hash = NilableHash[
      :present => 'value', :b1 => '', 'nilval' => nil, 'b2' => '', 'another' => 'another value'
    ]
  end

  it "should nilify all blank values" do
    @blank_hash.nilify_blanks
    expect(@blank_hash[:b1]).to be_nil
    expect(@blank_hash['b2']).to be_nil
  end

  it "should leave nils as nil" do
    expect(@blank_hash['nilval']).to be_nil
  end

  it "should not nilify non blank values" do
    expect(@blank_hash[:present]).to eq('value')
    expect(@blank_hash['another']).to eq('another value')
  end

  it "should respond true when sent #is_a?(Hash)" do
    expect(NilableHash.new.is_a?(Hash)).to be true
  end
end
