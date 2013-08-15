require "spec_helper"

describe "As a developer my config should be safe" do
  it "uses a tmp directory as the home for the spec" do
    expect(ENV["HOME"]).to_not eql(TEST_RUNNER_HOME)
  end
end
