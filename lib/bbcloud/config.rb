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

  def cache_path
    if @cache_path
      @cache_path
    else
      @cache_path = File.join(@dir, 'cache')
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

  def to_fog
    raise Ini::Error, "No api client configured" if clients.empty?
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
