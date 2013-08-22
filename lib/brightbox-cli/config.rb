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
    include Brightbox::Config::ToFog

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
      return @config if @config
      return {} if @config == false

      unless config_directory_exists?
        create_directory
      end

      @config ||= Ini.new config_filename
      @config
    rescue Ini::Error => e
      raise BBConfigError, "Config problem in #{config_filename}: #{e}"
    end

    def [](k)
      config[k]
    end

    def delete_section(name)
      config.delete_section name
    end

    def clients
      config.sections.find_all { |s| s != 'core' }
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

    def alias
      return nil if selected_config.nil?
      selected_config['alias']
    end

    def api_hostname
      URI(to_fog[:brightbox_api_url]).host
    rescue StandardError
      "api.gb1.brightbox.com"
    end

    # Write out the configuration file to disk
    def write_config_file
      if @config.is_a? Ini
        @config.write
      end
    end

    def finish
      begin
        save_access_token
        save_refresh_token
        write_config_file
      rescue BBConfigError
      rescue StandardError => e
        warn "Error writing auth token #{access_token_filename}: #{e.class}: #{e}"
      end
    end

    # Returns the currently CONFIGURED default client (ignoring which client is
    # asked for in this request)
    #
    # @return [String, NilClass] The client identifier or nil if not set
    #
    def default_client
      if @default_client
        @default_client
      else
        if config["core"]
          @default_client = config["core"]["default_client"]
        else
          nil
        end
      end
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

  private

    def default_config_dir
      File.join(ENV['HOME'],'.brightbox')
    end

    def selected_config
      config[client_name]
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
