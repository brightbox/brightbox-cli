require "spec_helper"

describe Brightbox::DatabaseSnapshot do
  subject(:database_snapshot) do
    Brightbox::DatabaseSnapshot.new("dbi-12345")
  end

  it_behaves_like "a wrapped API resource"
end
