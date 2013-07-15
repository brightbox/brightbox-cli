module Brightbox
  class BBConfigError < StandardError ; end

  class BBConfig
    require 'fileutils'
    require 'ini'
    include Brightbox::Config::Cache
    include Brightbox::Config::ToFog

    attr_writer :client_name, :account

    def initialize(options = {})
      @options = options
    end

    def self.config(force_default_config = true)
      $config = new(:force_default_config => force_default_config)
      require "brightbox-cli/gli_global_hooks"
      yield
    ensure
      $config.finish()
    end

    def dir
      return @dir if @dir
      return nil if @dir == false
      create_directory
      #
      if File.directory? @dir
        @dir
      else
        @dir = false
        nil
      end
    end

    def config_filename
      dir
      @config_filename
    end

    def oauth_token_filename
      @oauth_token_filename ||= File.join(dir, client_name + '.oauth_token')
    end

    def config
      return @config if @config
      return {} if @config == false
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

    def oauth_token
      return @oauth_token if defined?(@oauth_token)
      if File.exists?(oauth_token_filename)
        @oauth_token = read_cached_token
      else
        @oauth_token = nil
      end
    end

    def finish
      begin
        save_refresh_token
        if configured? && @oauth_token != Api.conn.access_token
          File.open(oauth_token_filename + ".#{$$}", "w") do |f|
            f.write Api.conn.access_token
          end
          FileUtils.mv oauth_token_filename + ".#{$$}", oauth_token_filename
        end
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

    def create_directory
      @dir = File.expand_path(@options[:dir] || default_config_dir)
      @config_filename = File.join(@dir, 'config')
      # Make the directory if necessary
      unless File.exists? @dir
        begin
          FileUtils.mkdir @dir
        rescue Errno::EEXIST
        end
      end
    end

    def read_cached_token
      File.open(oauth_token_filename, "r") { |fl| fl.read.chomp }
    end

  end
end
