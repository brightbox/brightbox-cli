__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), "..","lib"))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

require "brightbox_cli"
require "mocha"
require "vcr"
require "support/common_helpers"

Brightbox.const_set(:CONFIG,Brightbox::BBConfig.new())

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.extend VCR::RSpec::Macros
  config.include CommonHelpers
  config.before(:each) do
    connection_data = {
      :provider => "Brightbox",
      :brightbox_api_url => "https://api.gb1s.brightbox.com",
      :brightbox_auth_url => "https://api.gb1s.brightbox.com",
      :brightbox_client_id => "hello",
      :brightbox_secret => "world"
    }
    Brightbox::BBConfig.any_instance.stubs(:to_fog).returns(connection_data)
    Brightbox::BBConfig.any_instance.stubs(:oauth_token).returns("hello_world")
    Brightbox::BBConfig.any_instance.stubs(:configured?).returns(true)
  end
end

VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__),"fixtures/vcr_cassettes")
  c.allow_http_connections_when_no_cassette = true
  c.stub_with :excon
end
