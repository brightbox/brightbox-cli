__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__)))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

vendor_dir = File.join(__LIB_DIR__, '../vendor/')

unless defined?(DISABLE_RUBYGEMS)
  require "rubygems"
  gem "json", "~> 1.4.6"
  gem "fog", "~> 0.8.0" unless File.exist? vendor_dir + 'fog'
end

# Add any vendored libraries into search path
Dir.glob(vendor_dir + '*').each do |f|
  $:.unshift File.join(f, 'lib')
end

require "json"
require 'date'
require 'gli'
require 'fog'


require 'bbcloud/tables'
require "bbcloud/fog_extensions"
require "bbcloud/logging"
require "bbcloud/api"
require "bbcloud/servers"
require "bbcloud/images"
require "bbcloud/types"
require "bbcloud/zones"
require "bbcloud/cloud_ips"
require "bbcloud/users"
require "bbcloud/accounts"
require "bbcloud/config"
require "bbcloud/version"
require "bbcloud/load_balancers"
require "bbcloud/ruby_core_ext"
require "bbcloud/error_parser"

