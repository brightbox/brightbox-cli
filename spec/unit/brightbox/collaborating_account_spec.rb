require "spec_helper"

describe Brightbox::CollaboratingAccount do
  subject(:account) do
    data = {
      "id" => "acc-12345"
    }
    account_model = Fog::Compute::Brightbox::Account.new(data)
    Brightbox::CollaboratingAccount.new(account_model)
  end

  it_behaves_like "a wrapped API resource"

  it { should respond_to(:ram_free) }
  it { should respond_to(:cloud_ip_limit) }
  it { should respond_to(:lb_limit) }
end
