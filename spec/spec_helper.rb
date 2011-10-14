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
end

VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__),"fixtures/vcr_cassettes")
  c.allow_http_connections_when_no_cassette = true
  c.stub_with :excon
end
