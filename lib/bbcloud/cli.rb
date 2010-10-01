require 'rubygems'
require 'fog'
require 'date'
require 'gli'
require 'hirb'

include GLI

API = Fog::Brightbox::Compute.new(
                                  :brightbox_auth_url => "http://api.gb1.eu.brightbox.com",
                                  :brightbox_api_url => "http://api.gb1.eu.brightbox.com",
                                  :brightbox_client_id => "cli-733iz",
                                  :brightbox_secret => "wq2r01u01i2gfig"
                                  )

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

def render_table(data, options = {})
  Hirb::Helpers::Table.render(data, options)
end
