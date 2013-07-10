require "spec_helper"

describe Brightbox::Account do
  subject(:account) do
    Brightbox::Account.new("acc-12345")
  end

  it_behaves_like "a wrapped API resource"

  it { should respond_to(:ram_free) }
  it { should respond_to(:cloud_ip_limit) }
  it { should respond_to(:lb_limit) }
end
