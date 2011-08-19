lib_dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

os_config = File.join(lib_dir,"bbcloud","os_config.rb")
require os_config if File.exist? os_config

vendor_dir = File.expand_path(File.join(lib_dir, 'bbcloud','vendor'))

# Add any vendored libraries into search path
Dir.glob(vendor_dir + '/*').each do |f|
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

