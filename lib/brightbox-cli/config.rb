module Brightbox
  class BBConfigError < StandardError ; end

  class NoSelectedClientError < BBConfigError; end
  NO_CLIENT_MESSAGE = "You must specify client to use with --client or set default client"

  class AmbiguousClientError < BBConfigError; end
  AMBIGUOUS_CLIENT_ERROR = "You must specify a default client using brightbox config client_default"

  class BBConfig
    require 'fileutils'
    require 'ini'
    include Brightbox::Logging
    include Brightbox::Config::Cache
    include Brightbox::Config::GpgEncryptedPasswords
    include Brightbox::Config::PasswordHelper
    include Brightbox::Config::AuthenticationTokens
    include Brightbox::Config::Accounts
    include Brightbox::Config::Clients
    include Brightbox::Config::Sections
    include Brightbox::Config::ToFog
    include Brightbox::Config::Dirty

    attr_accessor :client_name
    attr_writer :account

    # @params [Hash] options Options to control loading and settings
    # @option options [String] :directory A path to the directory where config and
    #   cached and located. Otherwise a default of +$HOME/.brightbox+ is used
    # @option options [Boolean] :force_default_config
    # @option options [String] :client_name The name of the client whose config
    #   section to use
    # @option options [String] :account The scoped account to use overriding the
    #   saved configuration
    #
    def initialize(options = {})
      @options = options
      prepare_dir
      prepare_ini
      @client_name = determine_client(options[:client_name])
      @account = determine_account(options[:account])
      @dirty = false
    end

    # The String path to the configuration directory
    #
    # @return [String]
    def config_directory
      return @dir if @dir
      path = @options[:directory] || default_config_dir
      @dir = File.expand_path(path)
    end

    # Returns +true+ if the +config_directory+ exists on disk
    #
    # @return [Boolean]
    def config_directory_exists?
      File.exist?(config_directory) && File.directory?(config_directory)
    end

    # The String path to the configuration file itself (in .ini format)
    #
    # @return [String]
    def config_filename
      return @config_filename if @config_filename
      @config_filename = File.join(config_directory, 'config')
    end

    # The loads the configuration from disk or creates the directory if missing
    # and caches the details.
    #
    # @return [Ini] The raw settings from the ini configuration file
    def config
      @config_file
    end

    # Write out the configuration file to disk
    def save
      if dirty? && config.respond_to?(:write)
        config.write
        clean_up
      end
    end

    # Outputs to debug the current values of the config/client's tokens
    #
    def debug_tokens
      if ENV["DEBUG"]
        debug "Access token: #{access_token} (#{cached_access_token})"
        if using_application?
          debug "Refresh token: #{refresh_token} (#{cached_refresh_token}))"
        else
          debug "Refresh token: <NOT EXPECTED FOR CLIENT>"
        end
      end
    end

    # Returns the core
    def core_setting(setting)
      config["core"][setting]
    end

    def set_core_setting(key, value)
      dirty! unless value == core_setting(key)
      config["core"][key] = value
    end

    private

    def default_config_dir
      File.join(ENV['HOME'], '.brightbox')
    end

    def configured?
      if client_name.nil? || config[client_name].nil?
        raise BBConfigError, "client id or alias #{client_name.inspect} not defined in config"
      end
      true
    end

    # Attempts to create the directory the config is expecting to find it's file
    # in
    #
    def create_directory
      unless File.exist? config_directory
        begin
          FileUtils.mkdir config_directory
        rescue Errno::EEXIST
        end
      end
    end

    def prepare_dir
      create_directory unless config_directory_exists?
    end

    def prepare_ini
      return @config_file if @config_file
      return {} if @config_file == false

      @config_file ||= Ini.new(config_filename)
      @config_file
    rescue Ini::Error => e
      raise BBConfigError, "Config problem in #{config_filename}: #{e}"
    end
  end
end
