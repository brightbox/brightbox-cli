module Brightbox
  module Config
    module AuthenticationTokens
      attr_writer :access_token, :refresh_token

      def oauth_token_filename
        @access_token_filename ||= File.join(config_directory, client_name + '.oauth_token')
      end

      def access_token
        if defined?(@access_token) && !@access_token.nil?
          return @access_token
        end
        if File.exists?(oauth_token_filename)
          @access_token = read_cached_token
        else
          @access_token = nil
        end
      end

      def refresh_token
        if defined?(@refresh_token) && !@refresh_token.nil?
          return @refresh_token
        end
        if selected_config["refresh_token"]
          @refresh_token = selected_config["refresh_token"]
         else
          @refresh_token = nil
        end
      end

      # @deprecation use access_token instead
      def oauth_token
        debug "WARN: oauth_token is deprecated, use access_token instead"
        access_token
      end

      # This stores the access token for the Fog service currently in use to
      # authenticate with the API.
      #
      def save_access_token
        if configured? && @oauth_token != Api.conn.access_token
          File.open(oauth_token_filename + ".#{$$}", "w") do |f|
            f.write Api.conn.access_token
          end
          FileUtils.mv oauth_token_filename + ".#{$$}", oauth_token_filename
        end
      end

      # This stores the refresh token for the Fog service currently in use to
      # request a new access token when current one has expired.
      #
      # @todo Store refresh token in file
      #
      def save_refresh_token
        if Api.conn.refresh_token && !Api.conn.refresh_token.empty?
          selected_config['refresh_token'] = Api.conn.refresh_token
        end
      end

      def update_refresh_token
        return false unless using_application?
        require 'highline'
        highline = HighLine.new()
        highline.say("Your API credentials have expired, enter your password to update them.")
        password = highline.ask("Enter your password : ") { |q| q.echo = false }
        fetch_refresh_token(:password => password)
        highline.say("Your API credentials have been updated, please re-run your command.")
        true
      end

      def fetch_refresh_token(options)
        self.client_name = options[:client_id]
        client_config = config[client_name]
        user_application = Brightbox::Config::UserApplication.new(client_config, client_name)
        # replace this portion with code that actually fetches a token
        client_config['refresh_token'] = user_application.fetch_refresh_token(options)
      end

    private

      def read_cached_token
        File.open(oauth_token_filename, "r") { |fl| fl.read.chomp }
      end

    end
  end
end
