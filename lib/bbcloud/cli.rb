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

def error(s)
  STDERR.write("#{s}\n")
end

def info(s)
  STDOUT.write("#{s}\n")
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
  rows = rows.collect { |row| row.to_row }
  if options[:global][:s]
    rows.each do |row|
      info options[:fields].collect { |k| row[k] }.join("\t")
    end
  else
    info Hirb::Helpers::Table.render(rows, options)
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

# Global options
desc "Simple output (tab separated, don't draw fancy tables)"
switch [:s, :simple]

desc "Set the api client to use (named in #{CONFIG.config_filename})"
flag [:c, :client]

# Load the command libraries for the current group
command_group_name = File.basename(ENV['_']).gsub(/^brightbox\-/,'')
Dir.glob(File.join(File.dirname(__FILE__), "commands/#{command_group_name}*.rb")).each do |f|
  load f
end

pre do |global_options,command,options,args|
  CONFIG.client_name = global_options[:c] if global_options[:c]
  true
end

run ARGV
