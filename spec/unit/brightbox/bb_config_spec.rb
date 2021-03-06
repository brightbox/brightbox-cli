require "spec_helper"

describe Brightbox::BBConfig do
  let(:config) { Brightbox::BBConfig.new }

  # These are initial specs that need fleshing out. We don't really need any of
  # these when whe actually are testing each by themselves!
  it { expect(config).to respond_to(:config) }
  it { expect(config).to respond_to(:config_directory) }
  it { expect(config).to respond_to(:config_filename) }
  it { expect(config).to respond_to(:delete_section) }
  it { expect(config).to respond_to(:client_name) }
  it { expect(config).to respond_to(:access_token_filename) }
  it { expect(config).to respond_to(:refresh_token_filename) }
  it { expect(config).to respond_to(:save) }

  # From Brightbox::Config::ToFog
  it { expect(config).to respond_to(:to_fog) }
  it { expect(config).to respond_to(:account) }
  it { expect(config).to respond_to(:find_or_set_default_account) }
  it { expect(config).to respond_to(:using_api_client?) }
  it { expect(config).to respond_to(:using_application?) }

  # From Brightbox::Config::Cache
  it { expect(config).to respond_to(:cache_path) }
  it { expect(config).to respond_to(:save_default_account) }
  it { expect(config).to respond_to(:cache_id) }
end
