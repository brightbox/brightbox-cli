module Brightbox
  module Config
    class ApiClient
      NON_BLANK_KEYS = %w[api_url client_id secret].freeze

      attr_accessor :selected_config, :client_name

      def initialize(incoming_config, client_name)
        @selected_config = incoming_config
        @client_name = client_name
      end

      def to_fog
        check_required_params
        {
          :provider => "Brightbox",
          :brightbox_api_url => selected_config["api_url"],
          :brightbox_auth_url => selected_config["auth_url"] || selected_config["api_url"],
          :brightbox_client_id => selected_config["client_id"],
          :brightbox_secret => selected_config["secret"],
          :persistent => persistent?
        }
      end

      def valid?
        NON_BLANK_KEYS.all? do |key|
          selected_config.key?(key) && !selected_config[key].to_s.empty?
        end
      end

      private

      def persistent?
        !(selected_config["persistent"] == "false")
      end

      def check_required_params
        unless valid?
          NON_BLANK_KEYS.each do |key|
            unless selected_config.key?(key) && !selected_config[key].to_s.empty?
              raise Brightbox::BBConfigError, "#{key} option missing from config in section #{client_name}"
            end
          end
        end
      end
    end
  end
end
