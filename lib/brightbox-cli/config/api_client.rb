module Brightbox
  module Config
    class ApiClient
      attr_accessor :selected_config, :client_name
      def initialize(incoming_config,client_name)
        @selected_config = incoming_config
        @client_name = client_name
      end

      def to_fog
        {
          :provider => 'Brightbox',
          :brightbox_api_url => selected_config['api_url'],
          :brightbox_auth_url => selected_config['auth_url'] || selected_config['api_url'],
          :brightbox_client_id => selected_config['client_id'],
          :brightbox_secret => selected_config['secret'],
          :persistent => (selected_config["persistent"] != nil ? selected_config["persistent"] : true)
        }
      end

      private
      def check_required_params
        %w{api_url client_id secret}.each do |k|
          if selected_config[k].to_s.empty?
            raise Brightbox::BBConfigError, "#{k} option missing from config in section #{client_name}"
          end
        end
      end

    end
  end
end
