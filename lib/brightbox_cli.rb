unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller.first), path.to_str)
    end
  end
end

lib_dir = __dir__

$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

os_config = File.join(lib_dir, "brightbox-cli", "os_config.rb")
require os_config if File.exist? os_config

vendor_dir = File.expand_path(File.join(lib_dir, "brightbox-cli", "vendor"))

# Add any vendored libraries into search path
Dir.glob("#{vendor_dir}/*").each do |f|
  $LOAD_PATH.unshift File.join(f, "lib")
end

require "multi_json"
require "date"
require "gli"
require "i18n"
require "fog/brightbox"

# I18n stuff to clean up scattered text everywhere
I18n.enforce_available_locales = false
I18n.default_locale = :en
I18n.load_path = [File.join("#{File.dirname(__FILE__)}/../locales/en.yml")]

module Brightbox
  DEFAULT_API_ENDPOINT = ENV.fetch("BRIGHTBOX_API_URL", "https://api.gb1.brightbox.com")
  EMBEDDED_APP_ID = "app-12345".freeze
  EMBEDDED_APP_SECRET = "mocbuipbiaa6k6c".freeze

  autoload :Server, File.expand_path("brightbox-cli/servers", __dir__)
  autoload :DetailedServer, File.expand_path("brightbox-cli/detailed_server", __dir__)
  autoload :Image, File.expand_path("brightbox-cli/images", __dir__)
  autoload :Type, File.expand_path("brightbox-cli/types", __dir__)
  autoload :Zone, File.expand_path("brightbox-cli/zones", __dir__)
  autoload :CloudIP, File.expand_path("brightbox-cli/cloud_ips", __dir__)
  autoload :User, File.expand_path("brightbox-cli/users", __dir__)
  autoload :Account, File.expand_path("brightbox-cli/accounts", __dir__)
  autoload :CollaboratingAccount, File.expand_path("brightbox-cli/collaborating_account", __dir__)
  autoload :LoadBalancer, File.expand_path("brightbox-cli/load_balancers", __dir__)
  autoload :ServerGroup, File.expand_path("brightbox-cli/server_groups", __dir__)
  autoload :DetailedServerGroup, File.expand_path("brightbox-cli/detailed_server_group", __dir__)
  autoload :FirewallPolicy, File.expand_path("brightbox-cli/firewall_policy", __dir__)
  autoload :FirewallRule, File.expand_path("brightbox-cli/firewall_rule", __dir__)
  autoload :FirewallRules, File.expand_path("brightbox-cli/firewall_rules", __dir__)
  autoload :Collaboration, File.expand_path("brightbox-cli/collaboration", __dir__)
  autoload :UserCollaboration, File.expand_path("brightbox-cli/user_collaboration", __dir__)
  autoload :DatabaseType, File.expand_path("brightbox-cli/database_type", __dir__)
  autoload :DatabaseServer, File.expand_path("brightbox-cli/database_server", __dir__)
  autoload :DatabaseSnapshot, File.expand_path("brightbox-cli/database_snapshot", __dir__)
  autoload :Volume, File.expand_path("brightbox-cli/volume", __dir__)
  autoload :Token, File.expand_path("brightbox-cli/token", __dir__)

  module Config
    autoload :SectionNameDeduplicator, File.expand_path("brightbox-cli/config/section_name_deduplicator", __dir__)
  end
end

require_relative "brightbox/cli/config"

require_relative "brightbox-cli/connection_manager"
require_relative "brightbox-cli/tables"
require_relative "brightbox-cli/logging"
require_relative "brightbox-cli/api"
require_relative "brightbox-cli/config/cache"
require_relative "brightbox-cli/config/gpg_encrypted_passwords"
require_relative "brightbox-cli/config/password_helper"
require_relative "brightbox-cli/config/two_factor_auth"
require_relative "brightbox-cli/config/two_factor_helper"
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
