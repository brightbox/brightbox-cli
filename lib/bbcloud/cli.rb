os_config = File.join(File.dirname(__FILE__), 'os_config.rb')
require os_config if File.exist? os_config

require "rubygems" unless defined?(DISABLE_RUBYGEMS)

# Add any vendored libraries into search path
Dir.glob(File.join(File.dirname(__FILE__), 'vendor/*')).each do |f|
  $:.unshift File.join(f, 'lib')
end

begin
  require 'json/ext'
rescue LoadError
  require 'json/pure'
end

require 'date'
require 'gli'
require 'bbcloud/tables'
require 'brightbox-fog'

%w{api servers images types zones cloud_ips users accounts config version}.each do |f|
  require File.join(File.dirname(__FILE__), f)
end

CONFIG = BBConfig.new

include Brightbox
include GLI

class Time
  def rfc8601
    self.strftime("%Y-%m-%dT%H:%M")
  end
  def to_s
    rfc8601
  end
end

def error(s='')
  STDERR.write s
  STDERR.write "\n"
  STDERR.flush
end

def info(s='')
  STDERR.write s
  STDERR.write "\n"
  STDERR.flush
end

def warn(s='')
  info "WARN: #{s}"
end

def data(s)
  STDOUT.write s
  STDOUT.write "\n"
end

def debug(s)
  if ENV['DEBUG']
    STDERR.write "DEBUG: "
    STDERR.write s
    STDERR.write "\n"
  end
end

# Global options
desc "Simple output (tab separated, don't draw fancy tables)"
switch [:s, :simple]

desc "Set the api client to use (named in #{CONFIG.config_filename})"
flag [:c, :client]

# Load the command libraries for the current group
cmd_group_name = File.basename($0).gsub(/brightbox\-/,'')
cmd_group_files = File.join(File.dirname(__FILE__), "commands/#{cmd_group_name}*.rb")
Dir.glob(cmd_group_files).each do |f|
  load f
end

pre do |global_options,command,options,args|
  CONFIG.client_name = global_options[:c] if global_options[:c]
  info "INFO: client_id: #{CONFIG.client_name}" if CONFIG.clients.size > 1
  true
end

on_error do |e|
  case e
  when Excon::Errors::ServiceUnavailable
    error "Api currently unavailable"
  when Excon::Errors::Error
    if e.respond_to?(:response) and e.response.respond_to?(:body)
      r = JSON.parse(e.response.body) rescue {}
      if r['error']
        if r['error'].is_a? Hash
          # Most API errors
          r = r['error']
          error "ERROR: #{e.class}: #{r['name']}: #{r['summary']}"
        else
          # Auth error
          error "ERROR: #{e.class}: #{r['error']}: #{r['error_description']}"
        end
      else
        error "ERROR: #{e}"
      end
    else
      error "ERROR: #{e}"
    end           
  else
    error "ERROR: #{e}"
  end
  debug e
  debug e.class.to_s
  debug e.backtrace.join("\n")
  exit 1
end

desc 'Display version information'
command [:version] do |c|
  c.action do |global_options, options, args|
    info "Brightbox CLI version: #{Brightbox::VERSION}"
  end
end

run ARGV
