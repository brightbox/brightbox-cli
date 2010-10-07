require 'rubygems'
require 'date'
require 'gli'
require 'hirb'
require 'fog'

module Brightbox
  class Api
    attr_reader :id
    class ApiError < StandardError ; end
    class NotFound < ApiError ; end

    @@api = nil

    def self.conn
      if @@api
        @@api
      else
        @@api = Fog::Brightbox::Compute.new CONFIG.to_fog
      end
    end

    def initialize(m = nil)
      if m.is_a? String
        @id = m
      elsif !m.nil?
        @fog_model = m
        @id = m.id
      end
    end

    def fog_model
      @fog_model ||= self.class.find(@id)
    end

    def exists?
      !fog_model.nil?
    rescue NotFound
      false
    end

    def to_s
      @id
    end

    def self.find(args = :all, options = {})
      options = {
        :order => :created_at,
      }.merge options
      objects = []
      # get the data from the Api
      if args == :all or (args.respond_to?(:empty?) and args.empty?)
        objects = all
      elsif args.respond_to? :collect
        objects = args.collect do |arg|
          cached_get(arg)
        end
      end
      # wrap in our objects
      objects.collect! { |o| new(o) unless o.nil? }
      # Sort
      objects.sort! do |a,b| 
        sort_method = options[:order]
        begin
          a.send(sort_method) <=> b.send(sort_method)
        rescue NoMethodError
          0
        end
      end
      if objects.size == 1 and args.is_a? String
        # This was a single lookup
        objects.first
      else
        objects
      end
    end

    def method_missing(m, *args)
      if fog_model
        fog_model.send(m, *args)
      else
        raise NoMethodError
      end
    end

    def self.cached_get(id)
      @cache = {} if @cache.nil?
      value = @cache[id]
      if value
        value
      else
        debug "writing cache entry #{id}"
        @cache[id] = get(id)
      end
    end

    def self.find_by_handle(h)
      find(:all).find { |o| o.handle == h }
    end

  end
end

require File.join(File.dirname(__FILE__), '/servers')
require File.join(File.dirname(__FILE__), '/images')
require File.join(File.dirname(__FILE__), '/types')
require File.join(File.dirname(__FILE__), '/zones')
require File.join(File.dirname(__FILE__), '/cloud_ips')

require File.join(File.dirname(__FILE__), '/config')

CONFIG = BBConfig.new

include Brightbox
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

def debug(s)
  if ENV['DEBUG']
    STDERR.write "DEBUG: "
    STDERR.write s
    STDERR.write "\n"
  end
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
  info "client_id: #{CONFIG.client_name}" if CONFIG.clients.size > 1
  true
end

on_error do |e|
  error "ERROR: #{e}"
  debug e.backtrace.join("\n")
  exit 1
end

run ARGV
