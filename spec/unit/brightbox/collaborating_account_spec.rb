require "spec_helper"

describe Brightbox::CollaboratingAccount do
  subject(:account) do
    data = {
      "id" => "acc-12345"
    }
    account_model = Fog::Brightbox::Compute::Account.new(data)
    Brightbox::CollaboratingAccount.new(account_model)
  end

  it_behaves_like "a wrapped API resource"

  it { is_expected.to respond_to(:ram_free) }
  it { is_expected.to respond_to(:cloud_ip_limit) }
  it { is_expected.to respond_to(:lb_limit) }
end
