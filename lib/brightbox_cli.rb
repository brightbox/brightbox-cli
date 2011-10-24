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

module Brightbox
  autoload :Server, "brightbox-cli/servers"
  autoload :DetailedServer, "brightbox-cli/detailed_server"
  autoload :Image, "brightbox-cli/images"
  autoload :Type, "brightbox-cli/types"
  autoload :Zone, "brightbox-cli/zones"
  autoload :CloudIP, "brightbox-cli/cloud_ips"
  autoload :User, "brightbox-cli/users"
  autoload :Account, "brightbox-cli/accounts"
  autoload :LoadBalancer, "brightbox-cli/load_balancers"
  autoload :ServerGroup, "brightbox-cli/server_groups"
  autoload :DetailedServerGroup, "brightbox-cli/detailed_server_group"
  autoload :FirewallPolicy, "brightbox-cli/firewall_policy"
  autoload :FirewallRule, "brightbox-cli/firewall_rule"
  autoload :FirewallRules, "brightbox-cli/firewall_rules"
end

require 'brightbox-cli/tables'
require "brightbox-cli/fog_extensions"
require "brightbox-cli/logging"
require "brightbox-cli/api"
require "brightbox-cli/config"
require "brightbox-cli/version"
require "brightbox-cli/ruby_core_ext"
require "brightbox-cli/error_parser"
