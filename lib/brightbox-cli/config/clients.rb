module Brightbox
  module Config
    module Clients
      # Is the currently selected config using API client details?
      def using_api_client?
        config_identifier_match_prefix?("cli")
      end

      # Is the currently selected config using user application details?
      def using_application?
        if client_name
          !config[client_name]["username"].nil?
        else
          raise NoSelectedClientError, NO_CLIENT_MESSAGE
        end
      end

      # Does this config have multiple clients defined within?
      def has_multiple_clients?
        section_names.size > 1
      end

      # Does the currently selected client have an alias and a config section
      # set to the client ID is not a real alias
      #
      def client_has_alias?
        client_alias != client_id
      end

      # What is the currently selected client's alias
      #
      def client_alias
        return nil if selected_config.nil?
        # FIXME: The 'alias' field is redundant because we are using the section
        #   heading for the not ID value but we worry about it for now
        selected_config["alias"] || client_name
      end

      # Returns the actual client ID with no risk of an alias
      def client_id
        selected_config["client_id"] || Brightbox::EMBEDDED_APP_ID
      end

      # @todo Account for "core" section
      # @return [Boolean] +true+ if a client (section) has that name
      def client_named?(name)
        raw_sections.any? { |k, v| v["alias"] == name || k == name }
      end

      # @param [String] client_alias the name of the client to make the default
      def set_default_client(client_alias)
        dirty? unless client_alias == default_client
        @default_client = client_alias
        set_core_setting("default_client", client_alias)
      end

      # Returns the currently CONFIGURED default client (ignoring which client is
      # asked for in this request)
      #
      # @return [String, NilClass] The client identifier or nil if not set
      #
      def default_client
        @default_client ||= core_setting("default_client")
      rescue
        nil
      end

      def clear_default_client
        if config["core"].key?("default_client")
          config["core"].delete("default_client")
          dirty!
        end
        @default_client = nil
      end

      def determine_client(preferred_client = nil)
        return preferred_client unless preferred_client.nil?
        return default_client unless default_client.nil?
        section_names.first unless section_names.empty?
        nil
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
