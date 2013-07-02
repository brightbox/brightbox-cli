require "spec_helper"

describe NilableHash, "#nilify_blanks" do
  before do
    @blank_hash = NilableHash[
      :present => 'value', :b1 => '', 'nilval' => nil, 'b2' => '', 'another' => 'another value'
    ]
  end

  it "should nilify all blank values" do
    @blank_hash.nilify_blanks
    @blank_hash[:b1].should be_nil
    @blank_hash['b2'].should be_nil
  end

  it "should leave nils as nil" do
    @blank_hash['nilval'].should be_nil
  end

  it "should not nilify non blank values" do
    @blank_hash[:present].should == 'value'
    @blank_hash['another'].should == 'another value'
  end

  it "should respond true when sent #is_a?(Hash)" do
    NilableHash.new.is_a?(Hash).should be_true
  end
end
