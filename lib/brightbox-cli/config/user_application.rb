module Brightbox
  module Config
    class UserApplication
      # FIXME api_url should use fog's underlying default
      # FIXME refresh_token should not be in the config
      #
      NON_BLANK_KEYS = %w{api_url app_id app_secret refresh_token}

      attr_accessor :selected_config, :client_name

      def initialize(incoming_config, client_name)
        @selected_config = incoming_config
        @client_name = client_name
      end

      def to_fog
        check_required_params
        {
          :provider => 'Brightbox',
          :brightbox_api_url => selected_config['api_url'],
          :brightbox_auth_url => selected_config['auth_url'] || selected_config['api_url'],
          :brightbox_client_id => selected_config['app_id'],
          :brightbox_secret => selected_config['app_secret'],
          :brightbox_refresh_token => selected_config['refresh_token'],
          :persistent => (selected_config["persistent"] != nil ? selected_config["persistent"] : true)
        }
      end

      # Returns +true+ if the config section passed in has expected keys
      #
      # @todo Implementation requires keys that are really optional
      #
      def valid?
        NON_BLANK_KEYS.all? do |key|
          selected_config.has_key?(key) && ! selected_config[key].to_s.empty?
        end
      end

      # FIXME This calls the underlying fog methods which also resets the access
      # token but this method does not expose that token.
      #
      def fetch_refresh_token(options)
        default_fog_options = password_auth_params.merge(:brightbox_username => options[:email], :brightbox_password => options[:password])
        connection = Fog::Compute.new(default_fog_options)
        begin
          connection.get_access_token!
        rescue Excon::Errors::Unauthorized => e
          raise Brightbox::Api::ApiError, "Invalid credentials"
        end
        connection.refresh_token
      end

    private

      def password_auth_params
        {
          :provider => 'Brightbox',
          :brightbox_api_url => selected_config['api_url'],
          :brightbox_auth_url => selected_config['auth_url'] || selected_config['api_url'],
          :brightbox_client_id => selected_config['app_id'],
          :brightbox_secret => selected_config['app_secret'],
          :persistent => (selected_config["persistent"] != nil ? selected_config["persistent"] : true)
        }
      end

      def check_required_params
        unless valid?
          NON_BLANK_KEYS.each do |key|
            unless selected_config.has_key?(key) && ! selected_config[key].to_s.empty?
              raise Brightbox::BBConfigError, "#{key} option missing from config in section #{client_name}"
            end
          end
        end
      end
    end
  end
end
