module Brightbox
  module Config
    module Sections
      #
      # @param [String] client_alias
      # @param [String] client_id
      # @param [String] secret
      # @param [Hash] options
      # @option options [String] :username
      # @option options [String] :password
      # @option options [String] :api_url
      # @option options [String] :auth_url
      #
      def add_section(client_alias, client_id, secret, options)
        config_section = config[client_alias]
        if config_section.empty?
          info "Creating new client config #{client_alias}"
        else
          old_calias = client_alias

          deduplicator = Brightbox::Config::SectionNameDeduplicator.new(client_alias, section_names)
          client_alias = deduplicator.next
          # Need to open the new config again
          config_section = config[client_alias]

          info "A client config named #{old_calias} already exists using #{client_alias} instead"
        end

        config_section["alias"] = client_alias
        config_section["client_id"] = client_id
        config_section["username"] = options[:username]
        config_section["secret"] = secret
        config_section["api_url"] = options[:api_url] || DEFAULT_API_ENDPOINT
        config_section["auth_url"] = options[:auth_url] || config_section["api_url"]

        dirty!

        self.client_name = client_alias

        # Renew tokens via config...
        begin
          renew_tokens(:client_name => client_alias, :password => options[:password])
        rescue => e
          error "Something went wrong trying to refresh new tokens #{e.message}"
        end

        # Try to determine a default account
        unless default_account == find_or_set_default_account
          info "The default account of #{default_account} has been selected"
        end

        # If only client then set it as the default
        set_default_client(client_alias) unless default_client

        # Ensure all our config changes are now saved
        save
      end

      # Removes the config section from the configuration object. Must be
      # persisted to disk.
      #
      def delete_section(name)
        if client_named?(name)
          if default_client == name
            clear_default_client
          end
          # remove from the Ini object
          config.delete_section(name)

          dirty! # to ensure save actually writes to disk
          save
        end
      end

      # Config data for a named section
      #
      # @example
      #   @config["dev"] # => dev client data
      #
      # @param[String] section_name the name of the section
      #
      # @return [Hash] the data for the section
      #
      def [](section_name)
        config[section_name]
      end

      # Returns the section names in the config
      #
      # @return [Array<String>]
      #
      def section_names
        # Exclude the global "core" section
        config.sections.reject { |s| %w(core alias).include?(s) }
      end

      private

      # To compensate for Ini gem, this gets the hash it holds because it's
      # #each interface isn't much use
      def raw_sections
        sections = config.instance_variable_get(:@ini)
        sections.delete("core")
        sections
      end

      # The current client based on the client_name
      def selected_config
        config[client_name]
      end
    end
  end
end
