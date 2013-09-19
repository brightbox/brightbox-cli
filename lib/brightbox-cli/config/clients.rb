module Brightbox
  module Config
    module Clients

      # Is the currently selected config using API client details?
      def using_api_client?
        config_identifier_match_prefix?("cli")
      end

      # Is the currently selected config using user application details?
      def using_application?
        config_identifier_match_prefix?("app")
      end

    private

      # If the prefix is in the client ID (identifier not alias) be +true+
      def config_identifier_match_prefix?(prefix)
        client_id = selected_config["client_id"]
        !! /\A#{prefix}-.*/.match(client_id)
      rescue
        raise NoSelectedClientError, NO_CLIENT_MESSAGE
      end
    end
  end
end
