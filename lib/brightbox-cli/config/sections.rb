module Brightbox
  module Config
    module Sections

      # Removes the config section from the configuration object. Must be
      # persisted to disk.
      #
      def delete_section(name)
        config.delete_section(name)
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

      # Returns the clients in the config
      #
      # @return [Array<Hash>]
      #
      def clients
        # Exclude the global "core" section
        config.sections.find_all { |s| s != 'core' }
      end

      # The "alias" of the current client
      def alias
        return nil if selected_config.nil?
        selected_config["alias"]
      end

    private

      # The current client based on the client_name
      def selected_config
        config[client_name]
      end
    end
  end
end
