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
require 'hirb'
require 'fog'


%w{api servers images types zones cloud_ips users accounts config}.each do |f|
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


# Print nice ascii tables (or tab separated lists, depending on mode)
# Has lots of magic.
def render_table(rows, options = {})
  options = { :description => false }.merge options
  # Figure out the fields from the :model option
  if options[:model] and options[:fields].nil?
    options[:fields] = options[:model].default_field_order
  end
  # Figure out the fields from the first row
  if options[:fields].nil? and rows.first.class.respond_to?(:default_field_order)
    options[:fields] = rows.first.class.default_field_order
  end
  # Call to_row on all the rows
  rows = rows.collect do |row|
    row.respond_to?(:to_row) ? row.to_row : row
  end
  # Call render_cell on all the cells
  rows.each do |row|
    row.keys.each do |k|
      row[k] = row[k].render_cell if row[k].respond_to? :render_cell
    end
  end
  if options[:s]
    # Simple output
    rows.each do |row|
      if options[:vertical]
        data options[:fields].collect { |k| [k, row[k]].join("\t") }.join("\n")
      else
        data options[:fields].collect { |k| row[k] }.join("\t")
      end
    end
  else
    # "graphical" table
    if options[:vertical]
      data Hirb::Helpers::ShowTable.render(rows, options)
    else
      data Hirb::Helpers::Table.render(rows, options)
    end
  end
end

class Hirb::Helpers::ShowTable < Hirb::Helpers::Table

  def self.render(rows, options={})
    new(rows, {:escape_special_chars=>false, :resize=>false}.merge(options)).render
  end

  def setup_field_lengths
    @field_lengths = default_field_lengths
  end

  def render_header; []; end
  def render_footer; []; end

  def render_rows
    longest_header = Hirb::String.size @headers.values.sort_by {|e| Hirb::String.size(e) }.last
    @rows.map do |row|
      fields = @fields.map {|f|
        "#{Hirb::String.rjust(@headers[f], longest_header)}: #{row[f]}"
      }
      fields << "" if @rows.size > 1
      fields.compact.join("\n")
    end
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

run ARGV
