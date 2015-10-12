module Brightbox
  module Config
    module Clients
      # Is the currently selected config using API client details?
      def using_api_client?
        config_identifier_match_prefix?("cli")
      end

      # Is the currently selected config using user application details?
      def using_application?
        if selected_config
          !selected_config["username"].nil?
        else
          raise NoSelectedClientError, NO_CLIENT_MESSAGE
        end
      end

      # Does this config have multiple clients defined within?
      def has_multiple_clients?
        clients.size > 1
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

      # Returns a client name or raises depending on a number of factors.
      #
      # FIXME: This combines too much decision making into what appears to be a
      # getter.
      #
      # If a default_client is not set and there are more than one client it
      # raises an error because it is ambiguous which to use.
      #
      # If +force_default_config+ is passed in as false (for +config+ commands)
      # then it attempts to use the first config
      #
      # Calling +client_name+ within the +config+ command will break the config
      # command because you can no longer manage your config (and set a default)
      #
      # This has been fixed by short circuiting to return +nil+ in that case which
      # should never exist now.
      #
      def client_name
        if @client_name
          @client_name
        else
          # If we do not require a default client do not error if one is not set
          # TODO: Remove when certain unused
          if @options[:force_default_config] == false
            @client_name = default_client
          else
            # Is client ambigious?
            if default_client.nil? && clients.length > 1
              raise AmbiguousClientError, AMBIGUOUS_CLIENT_ERROR
            end
            @client_name = default_client || clients.first
          end
        end
      end

      # Returns the actual client ID with no risk of an alias
      def client_id
        selected_config["client_id"]
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
