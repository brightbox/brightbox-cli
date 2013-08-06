require "spec_helper"

describe Brightbox::UserCollaboration do
  subject(:user_collaboration) do
    Brightbox::UserCollaboration.new("acc-12345")
  end

  it_behaves_like "a wrapped API resource"
end
