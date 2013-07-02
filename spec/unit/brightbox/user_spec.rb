require "spec_helper"

describe Brightbox::User do
  subject(:user) do
    Brightbox::User.new("usr-12345")
  end

  it_behaves_like "a wrapped API resource"
end
