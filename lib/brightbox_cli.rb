unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller.first), path.to_str)
    end
  end
end

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
require "fog/brightbox/compute"

module Brightbox
  autoload :Server, File.expand_path("../brightbox-cli/servers", __FILE__)
  autoload :DetailedServer, File.expand_path("../brightbox-cli/detailed_server", __FILE__)
  autoload :Image, File.expand_path("../brightbox-cli/images", __FILE__)
  autoload :Type, File.expand_path("../brightbox-cli/types", __FILE__)
  autoload :Zone, File.expand_path("../brightbox-cli/zones", __FILE__)
  autoload :CloudIP, File.expand_path("../brightbox-cli/cloud_ips", __FILE__)
  autoload :User, File.expand_path("../brightbox-cli/users", __FILE__)
  autoload :Account, File.expand_path("../brightbox-cli/accounts", __FILE__)
  autoload :LoadBalancer, File.expand_path("../brightbox-cli/load_balancers", __FILE__)
  autoload :ServerGroup, File.expand_path("../brightbox-cli/server_groups", __FILE__)
  autoload :DetailedServerGroup, File.expand_path("../brightbox-cli/detailed_server_group", __FILE__)
  autoload :FirewallPolicy, File.expand_path("../brightbox-cli/firewall_policy", __FILE__)
  autoload :FirewallRule, File.expand_path("../brightbox-cli/firewall_rule", __FILE__)
  autoload :FirewallRules, File.expand_path("../brightbox-cli/firewall_rules", __FILE__)
end

require_relative "brightbox-cli/connection_manager"
require_relative 'brightbox-cli/tables'
require_relative "brightbox-cli/logging"
require_relative "brightbox-cli/api"
require_relative "brightbox-cli/config/cache"
require_relative "brightbox-cli/config/authentication_tokens"
require_relative "brightbox-cli/config/api_client"
require_relative "brightbox-cli/config/user_application"
require_relative "brightbox-cli/config/to_fog"
require_relative "brightbox-cli/config"
require_relative "brightbox-cli/version"
require_relative "brightbox-cli/ruby_core_ext"
require_relative "brightbox-cli/nilable_hash"
require_relative "brightbox-cli/error_parser"

require_relative "brightbox-cli/gli_global_hooks"
