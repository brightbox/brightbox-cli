module Brightbox
  module Config
    module Clients

      # Is the currently selected config using API client details?
      def using_api_client?
        client_id = selected_config["client_id"]
        !! /\Acli-.*/.match(client_id)
      end

      # Is the currently selected config using user application details?
      def using_application?
        client_id = selected_config["client_id"]
        !! /\Aapp-.*/.match(client_id)
      end
    end
  end
end