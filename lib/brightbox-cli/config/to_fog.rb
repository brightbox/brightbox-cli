module Brightbox
  module Config
    module ToFog
      def to_fog(require_account_flag = false)
        unless configured?
          raise Brightbox::BBConfigError, "No api client configured"
        end

        default_fog_options =
          if using_api_client?
            Brightbox::Config::ApiClient.new(selected_config,client_name).to_fog
          else
            Brightbox::Config::UserApplication.new(selected_config, client_name).to_fog
          end
        if oauth_token
          default_fog_options.update(:brightbox_access_token => oauth_token)
        end
        default_fog_options
      end

      def account
        return @account if defined?(@account) && @account
        find_or_set_default_account
        default_account = selected_config['default_account']
        if !default_account || default_account.empty?
          raise BBConfigError, "You must specify account to be used with --account option or set default account to use"
        end
        default_account
      end

      def find_or_set_default_account
        if !selected_config['default_account'] || selected_config['default_account'].empty?
          accounts = Account.all
          if accounts.size == 1
            @account = accounts.first.id
            selected_config['default_account'] = @account
          end
        end
      end

      def using_api_client?
        selected_config['client_id']
      end

      def using_application?
        selected_config['app_id']
      end
    end
  end
end
