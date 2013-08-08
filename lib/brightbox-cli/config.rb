module Brightbox
  class BBConfigError < StandardError ; end

  class BBConfig
    require 'fileutils'
    require 'ini'
    include Brightbox::Config::Cache
    include Brightbox::Config::AuthenticationTokens
    include Brightbox::Config::ToFog

    attr_writer :client_name, :account

    # @params [Hash] options Options to control loading and settings
    # @option options [String] :directory A path to the directory where config and
    #   cached and located. Otherwise a default of +$HOME/.brightbox+ is used
    # @option options [Boolean] :force_default_config
    #
    def initialize(options = {})
      @options = options
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

    def client_name
      if @client_name
        @client_name
      else
        default_client = config['core']['default_client']
        if @options[:force_default_config] && default_client.nil? && clients.length > 1
          raise BBConfigError, "You must specify a default client using brightbox-config client_default"
        end
        @client_name = default_client || clients.first
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
        warn "Error writing auth token #{oauth_token_filename}: #{e.class}: #{e}"
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
