module Brightbox
  module Config
    module ToFog
      def to_fog
        unless configured?
          raise Brightbox::BBConfigError, "No api client configured"
        end

        default_fog_options =
          if using_api_client?
            Brightbox::Config::ApiClient.new(selected_config, client_name).to_fog
          else
            Brightbox::Config::UserApplication.new(selected_config, client_name).to_fog
          end
        if access_token
          default_fog_options.update(:brightbox_access_token => access_token)
        end
        if refresh_token
          default_fog_options.update(:brightbox_refresh_token => refresh_token)
        end
        default_fog_options
      end
    end
  end
end
