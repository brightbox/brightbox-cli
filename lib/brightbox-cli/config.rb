module Brightbox
  class BBConfigError < StandardError ; end

  class BBConfig
    require 'fileutils'
    require 'ini'
    include Brightbox::Logging
    include Brightbox::Config::Cache
    include Brightbox::Config::AuthenticationTokens
    include Brightbox::Config::Accounts
    include Brightbox::Config::Clients
    include Brightbox::Config::Sections
    include Brightbox::Config::ToFog
    include Brightbox::Config::Dirty

    attr_writer :client_name, :account

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
      @client_name = options[:client_name]
      @account = options[:account]
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
      File.exists?(config_directory) && File.directory?(config_directory)
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
      return @config_file if @config_file
      return {} if @config_file == false

      unless config_directory_exists?
        create_directory
      end

      @config_file ||= Ini.new(config_filename)
      @config_file
    rescue Ini::Error => e
      raise BBConfigError, "Config problem in #{config_filename}: #{e}"
    end

    # Returns a client name or raises depending on a number of factors.
    #
    # FIXME This combines too much decision making into what appears to be a
    # getter.
    #
    # If a default_client is not set and there are more than one client it
    # raises an error because it is ambiguous which to use.
    #
    # If +force_default_config+ is passed in as false (for +config+ commands)
    # then it attempts to use the first config but this becomes random on 1.8.7
    #
    # Calling +client_name+ within the +config+ command will break the config
    # command because you can no longer manage your config (and set a default)
    #
    # This has been fixed by short circuiting to return +nil+ in that case which
    # should never exist now.
    #
    def client_name
      if @client_name
        @client_name
      else
        # If we do not require a default client do not error if one is not set
        # TODO Remove when certain unused
        if @options[:force_default_config] == false
          @client_name = default_client
        else
          # Is client ambigious?
          if default_client.nil? && clients.length > 1
            raise BBConfigError, "You must specify a default client using brightbox config client_default"
          end
          @client_name = default_client || clients.first
        end
      end
    end

    # Write out the configuration file to disk
    def save
      if dirty? && config.respond_to?(:write)
        config.write
      end
    end

    # @todo Account for "core" section
    # @return [Boolean] +true+ if a client (section) has that name
    def client_named?(name)
      !! clients.any? {|calias| calias == name }
    end

    # @param [String] client_alias the name of the client to make the default
    def set_default_client(client_alias)
      dirty? unless client_alias == default_client
      set_core_setting("default_client", client_alias)
    end

    # Returns the currently CONFIGURED default client (ignoring which client is
    # asked for in this request)
    #
    # @return [String, NilClass] The client identifier or nil if not set
    #
    def default_client
      @default_client ||= core_setting("default_client")
    end

    # Outputs to debug the current values of the config/client's tokens
    #
    def debug_tokens
      if ENV["DEBUG"]
        debug "Access token: #{access_token}"
        if using_application?
          debug "Refresh token: #{refresh_token}"
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
      File.join(ENV['HOME'],'.brightbox')
    end

    def configured?
      configured = client_name != nil && !clients.empty?
      if configured && (selected_config.nil? || selected_config.empty?)
        raise BBConfigError, "client id or alias #{client_name.inspect} not defined in config"
      end
      configured
    end

    # Attempts to create the directory the config is expecting to find it's file
    # in
    #
    def create_directory
      unless File.exists? config_directory
        begin
          FileUtils.mkdir config_directory
        rescue Errno::EEXIST
        end
      end
    end
  end
end
