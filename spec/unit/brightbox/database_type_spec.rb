require "spec_helper"

describe Brightbox::DatabaseType do
  subject(:database_type) do
    Brightbox::DatabaseType.new("dbt-12345")
  end

  it_behaves_like "a wrapped API resource"
end
