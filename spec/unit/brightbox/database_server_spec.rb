require "spec_helper"

describe Brightbox::DatabaseServer do
  subject(:database_server) do
    Brightbox::DatabaseServer.new("dbs-12345")
  end

  it_behaves_like "a wrapped API resource"
end
