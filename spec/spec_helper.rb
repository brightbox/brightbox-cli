__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), "..","lib"))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

require "brightbox_cli"
require "support/common_helpers"

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

API_CLIENT_CONFIG = File.join(File.dirname(__FILE__), "configs/api_client")
USER_APP_CONFIG   = File.join(File.dirname(__FILE__), "configs/user_application")

RSpec.configure do |config|
  config.include CommonHelpers

  config.before(:suite) do
    # Globally use API client credentials by default
    test_config = Brightbox::BBConfig.new(:directory => API_CLIENT_CONFIG)
    $config = test_config
  end
end
