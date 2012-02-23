module Brightbox
  class BBConfigError < StandardError ; end

  class BBConfig
    require 'fileutils'
    require 'ini'

    attr_writer :client_name

    def initialize(options = {})
      @options = options
    end

    def self.config
      Brightbox.const_set(:CONFIG, new())
      require "brightbox-cli/gli_global_hooks"
      yield
    ensure
      CONFIG.finish()
    end

    def dir
      return @dir if @dir
      return nil if @dir == false
      @dir = File.expand_path(@options[:dir] || default_config_dir)
      @config_filename = File.join(@dir, 'config')
      # Make the directory if necessary
      unless File.exists? @dir
        begin
          FileUtils.mkdir @dir
        rescue Errno::EEXIST
        end
      end
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

    def cache_path
      if @cache_path
        @cache_path
      else
        @cache_path = File.join(dir, 'cache')
        unless File.exists? @cache_path
          begin
            FileUtils.mkdir @cache_path
          rescue Errno::EEXIST
          end
        end
        @cache_path
      end
    end

    def cache_id(cid)
      FileUtils.touch(File.join(cache_path, cid)) unless cid.nil?
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

    def save!
      if @config.is_a? Ini
        @config.write
      end
    end

    def clients
      config.sections.find_all { |s| s != 'core' }
    end

    def client_name
      if @client_name
        @client_name
      else
        default_client = config['core']['default_client']
        @client_name = default_client || clients.first
      end
    end

    def alias
      return nil if config[client_name].nil?
      config[client_name]['alias']
    end

    def to_fog
      raise Ini::Error, "No api client configured" unless configured?
      c = config[client_name]
      %w{api_url client_id secret}.each do |k|
        if c[k].to_s.empty?
          raise BBConfigError, "#{k} option missing from config in section #{client_name}"
        end
      end
      {
        :provider => 'Brightbox',
        :brightbox_api_url => c['api_url'],
        :brightbox_auth_url => c['auth_url'] || c['api_url'],
        :brightbox_client_id => c['client_id'],
        :brightbox_secret => c['secret'],
        :persistent => (c["persistent"] != nil ? c["persistent"] : true)
      }
    end

    def api_hostname
      URI(to_fog[:brightbox_api_url]).host
    rescue StandardError
      "api.gb1.brightbox.com"
    end

    def oauth_token
      if @oauth_token.nil?
        if File.exists? oauth_token_filename
          File.open(oauth_token_filename, "r") do |f|
            @oauth_token = f.read.chomp
          end
          @oauth_token
        else
          @oauth_token = nil
        end
      else
        @oauth_token ? @oauth_token : nil
      end
    end

    def finish
      begin
        if configured? && @oauth_token != Api.conn.oauth_token
          File.open(oauth_token_filename + ".#{$$}", "w") do |f|
            f.write Api.conn.oauth_token
          end
          FileUtils.mv oauth_token_filename + ".#{$$}", oauth_token_filename
        end
      rescue BBConfigError
      rescue StandardError => e
        warn "Error writing auth token #{oauth_token_filename}: #{e.class}: #{e}"
      end
    end

    def configured?
      configured = client_name != nil && !clients.empty?
      if configured && (config[client_name].nil? || config[client_name].empty?)
        raise BBConfigError, "client id or alias #{client_name.inspect} not defined in config"
      end
      configured
    end

    private
    def default_config_dir
      File.join(ENV['HOME'],'.brightbox')
    end

  end
end
