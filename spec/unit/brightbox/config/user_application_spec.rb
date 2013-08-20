require "spec_helper"

describe Brightbox::Config::UserApplication do
  let(:client_name) { "app-12345" }
  let(:config) { Brightbox::BBConfig.new }
  let(:config_section) { config[client_name] }

  subject { Brightbox::Config::UserApplication.new(config_section, client_name) }

  it_behaves_like "a config section type"
end
