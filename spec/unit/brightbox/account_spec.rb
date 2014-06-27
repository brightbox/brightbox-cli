require "spec_helper"

describe Brightbox::Account do
  subject(:account) do
    Brightbox::Account.new("acc-12345")
  end

  it_behaves_like "a wrapped API resource"

  it { is_expected.to respond_to(:ram_free) }
  it { is_expected.to respond_to(:cloud_ip_limit) }
  it { is_expected.to respond_to(:lb_limit) }
end
