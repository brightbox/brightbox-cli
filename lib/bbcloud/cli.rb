require 'rubygems'
require 'date'
require 'gli'
require 'hirb'
require 'fog'
require 'fog/brightbox'
# Explicitly load the fog models so we can extend them
require 'fog/brightbox/models/compute/server'
require 'fog/brightbox/models/compute/flavor'
require 'fog/brightbox/models/compute/image'
require 'fog/brightbox/models/compute/zone'
# Extend the fog models
require File.join(File.dirname(__FILE__), '/servers')
require File.join(File.dirname(__FILE__), '/images')
require File.join(File.dirname(__FILE__), '/types')
require File.join(File.dirname(__FILE__), '/zones')

require File.join(File.dirname(__FILE__), '/config')

CONFIG = BBConfig.new

include GLI

class String
  def pad_to(i)
    s = self
    if s.size > i
      s = s[0..i-2] + "~"
    end
    "%-#{i}s" % s
  end
end

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

def data(s)
  STDOUT.write s
  STDOUT.write "\n"
end

def field(k,v, pad = 16)
  info "#{k.pad_to(pad)} #{v}"
end

class Hash
  def to_row
    self
  end
end

class NilClass
  def to_row
    {}
  end
end

def render_table(rows, options = {})
  options = { :description => false }.merge options
  rows = rows.collect { |row| row.respond_to?(:to_row) ? row.to_row : row }
  if options.fetch(:global, {})[:s]
    rows.each do |row|
      if options[:vertical]
        data options[:fields].collect { |k| [k, row[k]].join("\t") }.join("\n")
      else
        data options[:fields].collect { |k| row[k] }.join("\t")
      end
    end
  else
    if options[:vertical]
      options.delete(:vertical)
      data Hirb::Helpers::ShowTable.render(rows, options)
    else
      data Hirb::Helpers::Table.render(rows, options)
    end
  end
end

class Api
  @@api = nil

  def self.conn
    if @@api
      @@api
    else
      @@api = Fog::Brightbox::Compute.new CONFIG.to_fog
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
  info "client_id: #{CONFIG.client_name}" if CONFIG.clients.size > 1
  true
end

on_error do |e|
  error "ERROR: #{e}"
  #error e.backtrace
  exit 1
end

run ARGV
