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
          default_fog_options.update(:brightbox_access_token => access_token)
        end
        default_fog_options
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
