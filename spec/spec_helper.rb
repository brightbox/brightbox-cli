LIB_DIR = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

$LOAD_PATH.unshift LIB_DIR unless
  $LOAD_PATH.include?(LIB_DIR) || $LOAD_PATH.include?(File.expand_path(LIB_DIR))

require "brightbox_cli"
require "json"
require "tmpdir"

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

require "webmock/rspec"
WebMock.disable_net_connect!

# API_CLIENT_CONFIG_DIR = File.join(File.dirname(__FILE__), "configs/api_client")
# USER_APP_CONFIG_DIR   = File.join(File.dirname(__FILE__), "configs/user_application")

# API_CLIENT_CONFIG = Brightbox::BBConfig.new(:directory => API_CLIENT_CONFIG_DIR)
# USER_APP_CONFIG   = Brightbox::BBConfig.new(:directory => USER_APP_CONFIG_DIR)

# These are the contents
API_CLIENT_CONFIG_CONTENTS = File.read(File.join(File.dirname(__FILE__), "configs/api_client.ini"))
USER_APP_CONFIG_CONTENTS = File.read(File.join(File.dirname(__FILE__), "configs/user_app.ini"))

# Remember the $HOME of the test runner
TEST_RUNNER_HOME = ENV.fetch("HOME", nil)

# Reduce the default fog timeout
Fog.timeout = 10

RSpec.configure do |config|
  config.include CommonHelpers
  config.include ConfigHelpers
  config.include TokenHelpers
  config.include PasswordPromptHelpers

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  config.before do
    # For each test, point to the testing endpoint to make it safer and easier to
    # record from dev endpoints. Devs can DNS api.brightbox.localhost to their dev service
    stub_const("Brightbox::DEFAULT_API_ENDPOINT", ENV.fetch("BRIGHTBOX_API_URL", "http://api.brightbox.localhost"))
    # And set a sane terminal size for Hirb
    ENV["COLUMNS"] = "120"
    ENV["LINES"] = "120"
  end

  # For each test, isolate the testing users $HOME so that we control the config
  # and any cached values completely.
  config.around(:each) do |example|
    Dir.mktmpdir do |tmp_home|
      ENV["HOME"] = tmp_home
      Brightbox.config = nil
      example.run
      ENV["HOME"] = TEST_RUNNER_HOME
    end
  end
end
