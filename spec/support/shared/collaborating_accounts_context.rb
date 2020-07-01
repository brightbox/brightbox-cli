# fog has it's own lazy loading / autoloading thing which means we have to
# require models we want to reference in specs BEFORE we have used a Fog method
require "fog/brightbox/models/compute/account"
require "fog/brightbox/models/compute/user_collaboration"

shared_context "collaborating accounts" do
  # As returned from conn.accounts.all as an owned account
  let(:owned_account) do
    data = {
      "id" => "acc-12345",
      "resource_type" => "account",
      "url" => "https://api.gb1.brightbox.com/1.0/accounts/acc-12345",
      "name" => "Owned account name",
      "status" => "active",
      "ram_limit" => 3_200_000,
      "ram_used" => 3072,
      "cloud_ips_limit" => 32,
      "cloud_ips_used" => 0,
      "load_balancers_limit" => 5,
      "load_balancers_used" => 0
    }
    Fog::Brightbox::Compute::Account.new(data)
  end

  # As returned from conn.user_collaborations.all
  let(:active_collaboration) do
    data = {
      "id" => "col-12345",
      "resource_type" => "collaboration",
      "status" => "accepted",
      "role" => "admin",
      "account" => {
        "id" => "acc-12345",
        "name" => "Active collaboration name",
        "status" => "active"
      }
    }
    Fog::Brightbox::Compute::UserCollaboration.new(data)
  end

  # As returned from conn.user_collaborations.all
  let(:pending_collaboration) do
    data = {
      "id" => "col-12345",
      "resource_type" => "collaboration",
      "status" => "pending",
      "role" => "admin",
      "account" => {
        "id" => "acc-12345",
        "name" => "Pending collaboration name",
        "status" => "active"
      }
    }
    Fog::Brightbox::Compute::UserCollaboration.new(data)
  end
end
