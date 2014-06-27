unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller.first), path.to_str)
    end
  end
end

lib_dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

os_config = File.join(lib_dir, "brightbox-cli", "os_config.rb")
require os_config if File.exist? os_config

vendor_dir = File.expand_path(File.join(lib_dir, 'brightbox-cli', 'vendor'))

# Add any vendored libraries into search path
Dir.glob(vendor_dir + '/*').each do |f|
  $LOAD_PATH.unshift File.join(f, 'lib')
end

require "multi_json"
require 'date'
require 'gli'
require "i18n"
require "fog/brightbox"

# I18n stuff to clean up scattered text everywhere
I18n.enforce_available_locales = false
I18n.default_locale = :en
I18n.load_path = [File.join(File.dirname(__FILE__) + "/../locales/en.yml")]

module Brightbox
  DEFAULT_API_ENDPOINT = "https://api.gb1.brightbox.com"

  autoload :Server, File.expand_path("../brightbox-cli/servers", __FILE__)
  autoload :DetailedServer, File.expand_path("../brightbox-cli/detailed_server", __FILE__)
  autoload :Image, File.expand_path("../brightbox-cli/images", __FILE__)
  autoload :Type, File.expand_path("../brightbox-cli/types", __FILE__)
  autoload :Zone, File.expand_path("../brightbox-cli/zones", __FILE__)
  autoload :CloudIP, File.expand_path("../brightbox-cli/cloud_ips", __FILE__)
  autoload :User, File.expand_path("../brightbox-cli/users", __FILE__)
  autoload :Account, File.expand_path("../brightbox-cli/accounts", __FILE__)
  autoload :CollaboratingAccount, File.expand_path("../brightbox-cli/collaborating_account", __FILE__)
  autoload :LoadBalancer, File.expand_path("../brightbox-cli/load_balancers", __FILE__)
  autoload :ServerGroup, File.expand_path("../brightbox-cli/server_groups", __FILE__)
  autoload :DetailedServerGroup, File.expand_path("../brightbox-cli/detailed_server_group", __FILE__)
  autoload :FirewallPolicy, File.expand_path("../brightbox-cli/firewall_policy", __FILE__)
  autoload :FirewallRule, File.expand_path("../brightbox-cli/firewall_rule", __FILE__)
  autoload :FirewallRules, File.expand_path("../brightbox-cli/firewall_rules", __FILE__)
  autoload :Collaboration, File.expand_path("../brightbox-cli/collaboration", __FILE__)
  autoload :UserCollaboration, File.expand_path("../brightbox-cli/user_collaboration", __FILE__)
  autoload :DatabaseType, File.expand_path("../brightbox-cli/database_type", __FILE__)
  autoload :DatabaseServer, File.expand_path("../brightbox-cli/database_server", __FILE__)
  autoload :DatabaseSnapshot, File.expand_path("../brightbox-cli/database_snapshot", __FILE__)

  module Config
    autoload :SectionNameDeduplicator, File.expand_path("../brightbox-cli/config/section_name_deduplicator", __FILE__)
  end
end

require_relative "brightbox-cli/connection_manager"
require_relative 'brightbox-cli/tables'
require_relative "brightbox-cli/logging"
require_relative "brightbox-cli/api"
require_relative "brightbox-cli/config/cache"
require_relative "brightbox-cli/config/authentication_tokens"
require_relative "brightbox-cli/config/accounts"
require_relative "brightbox-cli/config/clients"
require_relative "brightbox-cli/config/sections"
require_relative "brightbox-cli/config/api_client"
require_relative "brightbox-cli/config/user_application"
require_relative "brightbox-cli/config/to_fog"
require_relative "brightbox-cli/config/dirty"
require_relative "brightbox-cli/config"
require_relative "brightbox-cli/version"
require_relative "brightbox-cli/ruby_core_ext"
require_relative "brightbox-cli/nilable_hash"
require_relative "brightbox-cli/error_parser"

require_relative "brightbox-cli/gli_global_hooks"
