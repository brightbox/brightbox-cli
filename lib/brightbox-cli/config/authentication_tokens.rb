module Brightbox
  module Config
    module AuthenticationTokens
      attr_writer :access_token, :refresh_token

      def access_token_filename
        @access_token_filename ||= File.join(config_directory, client_name + '.oauth_token')
      end

      def access_token
        if defined?(@access_token) && !@access_token.nil?
          return @access_token
        end
        if File.exists?(access_token_filename)
          @access_token = cached_access_token
        else
          @access_token = nil
        end
      end

      def refresh_token_filename
        @refresh_token_filename ||= File.join(config_directory, client_name + '.refresh_token')
      end

      def refresh_token
        if defined?(@refresh_token) && !@refresh_token.nil?
          return @refresh_token
        end
        if File.exists?(refresh_token_filename)
          @access_token = cached_refresh_token
        else
          @access_token = nil
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
          File.open(access_token_filename + ".#{$$}", "w") do |f|
            f.write Api.conn.access_token
          end
          FileUtils.mv access_token_filename + ".#{$$}", access_token_filename
        end
      end

      # This stores the refresh token for the Fog service currently in use to
      # request a new access token when current one has expired.
      #
      def save_refresh_token
        if configured? && @refresh_token != Api.conn.refresh_token
          File.open(refresh_token_filename + ".#{$$}", "w") do |f|
            f.write Api.conn.refresh_token
          end
          FileUtils.mv refresh_token_filename + ".#{$$}", refresh_token_filename
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
        save_fresh_token
      end

    private

      def cached_access_token
        File.open(access_token_filename, "r") { |fl| fl.read.chomp }
      end

      def cached_refresh_token
        File.open(refresh_token_filename, "r") { |fl| fl.read.chomp }
      end
    end
  end
end
