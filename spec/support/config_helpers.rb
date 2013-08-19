require "fileutils"
require "securerandom"

module ConfigHelpers

  # Returns a Brightbox::BBConfig based on the String as its contents
  #
  # It's like a fake configuration - IN A CAN!
  #
  def config_from_contents(contents)
    # Create it (with a non existing file)
    config = Brightbox::BBConfig.new

    # Load the contents into the expected location
    FileUtils.mkdir_p config.config_directory
    File.open(config.config_filename, "w") do |f|
      f.write contents
    end

    config
  end

  # Returns the cached access token for the config directly from disk
  def cached_access_token(config)
    File.read(config.oauth_token_filename).chomp
  end

  # Returns +true+ if the token appears in the config
  def cached_refresh_token_in?(config, token)
    File.read(config.config_filename).include?(token)
  end

  # This returns a token like string with no meaning but should always be
  # different so never clashes in tests.
  def random_token
    SecureRandom.hex(20)
  end
end
