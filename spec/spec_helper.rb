__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), "..","lib"))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

require "brightbox_cli"
require "mocha/api"
require "vcr"
require "support/common_helpers"

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.extend VCR::RSpec::Macros
  config.include CommonHelpers

  config.before(:suite) do
    config_dir = File.join(File.dirname(__FILE__), "fixtures/config_files")
    test_config = Brightbox::BBConfig.new(:dir => config_dir)
    Brightbox.const_set(:CONFIG, test_config)
  end
end

VCR.configure do |vcr|
  vcr.cassette_library_dir = File.join(File.dirname(__FILE__),"fixtures/vcr_cassettes")
  vcr.allow_http_connections_when_no_cassette = false
  vcr.hook_into :excon
  vcr.default_cassette_options = {
    :match_requests_on => [:method, :path]
  }
end
