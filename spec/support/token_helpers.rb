require "securerandom"

module TokenHelpers
  # Creates a cached access token for the config directly to disk
  def cache_access_token(config, token)
    File.open(config.access_token_filename, "w") { |f| f.write token }
  end

  # Creates a cached refresh token for the config directly to disk
  def cache_refresh_token(config, token)
    File.open(config.refresh_token_filename, "w") { |f| f.write token }
  end

  # Returns the cached access token for the config directly from disk
  def cached_access_token(config)
    File.read(config.access_token_filename).chomp
  end

  # Returns the cached refresh token for the config directly from disk
  def cached_refresh_token(config)
    File.read(config.refresh_token_filename).chomp
  end

  # This returns a token like string with no meaning but should always be
  # different so never clashes in tests.
  def random_token
    SecureRandom.hex(20)
  end
end
