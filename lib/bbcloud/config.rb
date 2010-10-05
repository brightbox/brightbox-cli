class BBConfigError < StandardError ; end

class BBConfig
  require 'fileutils'
  require 'ini'

  attr_writer :client_name

  def initialize(options = {})
    @options = options
  end

  def dir
    return @dir if @dir
    return nil if @dir == false
    @dir = File.expand_path(@options[:dir] || "~/.brightbox")
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

  def config
    return @config if @config
    return {} if @config == false
    @config ||= Ini.new config_filename
    raise Ini::Error, "No api client configured" if clients.empty?
    @config
  rescue Ini::Error => e
    raise BBConfigError, "Config problem in #{config_filename}: #{e}"
  end

  def clients
    config.sections.find_all { |s| s != 'core' }
  end

  def client_name
    ddefault_client = config['core']['default_client']
    @client_name = ddefault_client if ddefault_client
    @client_name ||= clients.first
  end

  def to_fog
    c = config[client_name]
    %w{api_url client_id secret}.each do |k|
      if c[k].to_s.empty?
        raise BBConfigError, "#{k} option missing from config in section #{client_name}"
      end
    end
    { 
      :brightbox_api_url => c['api_url'],
      :brightbox_auth_url => c['auth_url'] || c['api_url'],
      :brightbox_client_id => c['client_id'],
      :brightbox_secret => c['secret']
    }
  end


end
