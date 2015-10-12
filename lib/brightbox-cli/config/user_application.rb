module Brightbox
  module Config
    class UserApplication
      # FIXME: api_url should use fog's underlying default
      #
      NON_BLANK_KEYS = %w(api_url username)

      attr_accessor :selected_config, :client_name

      def initialize(incoming_config, client_name)
        @selected_config = incoming_config
        @client_name = client_name
      end

      def to_fog
        check_required_params
        # Note we have to merge in refresh token at the higher level
        {
          :provider => 'Brightbox',
          :brightbox_api_url => selected_config['api_url'],
          :brightbox_auth_url => selected_config['auth_url'] || selected_config['api_url'],
          :brightbox_client_id => client_id,
          :brightbox_secret => client_secret,
          :persistent => persistent?
        }
      end

      # Returns +true+ if the config section passed in has expected keys
      #
      # @todo Implementation requires keys that are really optional
      #
      def valid?
        NON_BLANK_KEYS.all? do |key|
          selected_config.key?(key) && !selected_config[key].to_s.empty?
        end
      end

      # FIXME: This calls the underlying fog methods which also resets the access
      # token but this method does not expose that token.
      #
      def fetch_refresh_token(options)
        password_options = {
          :brightbox_password => options[:password]
        }

        default_fog_options = password_auth_params.merge(password_options)
        connection = Fog::Compute.new(default_fog_options)
        begin
          connection.get_access_token!
        rescue Excon::Errors::Unauthorized
          raise Brightbox::Api::ApiError, "Invalid credentials"
        end
        connection
      end

      private

      def client_id
        selected_config["client_id"] || Brightbox::EMBEDDED_APP_ID
      end

      def client_secret
        selected_config["secret"] || Brightbox::EMBEDDED_APP_SECRET
      end

      def persistent?
        if selected_config["persistent"] == "false"
          false
        else
          true
        end
      end

      def password_auth_params
        {
          :provider => 'Brightbox',
          :brightbox_api_url => selected_config['api_url'],
          :brightbox_auth_url => selected_config['auth_url'] || selected_config['api_url'],
          :brightbox_client_id => client_id,
          :brightbox_secret => client_secret,
          :brightbox_username => selected_config["username"],
          :persistent => persistent?
        }
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
