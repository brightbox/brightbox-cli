lib_dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

os_config = File.join(lib_dir,"brightbox-cli","os_config.rb")
require os_config if File.exist? os_config

vendor_dir = File.expand_path(File.join(lib_dir, 'brightbox-cli','vendor'))

# Add any vendored libraries into search path
Dir.glob(vendor_dir + '/*').each do |f|
  $:.unshift File.join(f, 'lib')
end

require "json"
require 'date'
require 'gli'
require 'fog/brightbox'


require 'brightbox-cli/tables'
require "brightbox-cli/fog_extensions"
require "brightbox-cli/logging"
require "brightbox-cli/api"
require "brightbox-cli/servers"
require "brightbox-cli/images"
require "brightbox-cli/types"
require "brightbox-cli/zones"
require "brightbox-cli/cloud_ips"
require "brightbox-cli/users"
require "brightbox-cli/accounts"
require "brightbox-cli/config"
require "brightbox-cli/version"
require "brightbox-cli/load_balancers"
require "brightbox-cli/ruby_core_ext"
require "brightbox-cli/error_parser"


