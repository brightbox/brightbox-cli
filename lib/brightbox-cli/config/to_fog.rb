module Brightbox
  module Config
    module ToFog
      def to_fog
        raise Ini::Error, "No api client configured" unless configured?
        if using_api_client?
          Brightbox::Config::ApiClient.new(selected_config,client_name).to_fog
        else
          Brightbox::Config::UserApplication.new(selected_config, client_name).to_fog
        end

      end

      private
      def using_api_client?
        selected_config['client_id']
      end

      def using_application?
        selected_config['app_id']
      end

    end
  end
end
