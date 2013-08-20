require "spec_helper"

describe Brightbox::Config::ApiClient do
  let(:client_name) { "cli-12345" }
  let(:config) { Brightbox::BBConfig.new }
  let(:config_section) { config[client_name] }

  subject { Brightbox::Config::ApiClient.new(config_section, client_name) }

  it_behaves_like "a config section type"
end
