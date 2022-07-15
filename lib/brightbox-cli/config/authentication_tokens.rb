module Brightbox
  module Config
    module AuthenticationTokens
      attr_writer :access_token, :refresh_token

      def access_token_filename
        file_name = "#{base_token_name}.oauth_token"
        @access_token_filename ||= File.join(config_directory, file_name)
      end

      def access_token
        if defined?(@access_token) && !@access_token.nil?
          return @access_token
        end

        @access_token = if File.exist?(access_token_filename)
                          cached_access_token
                        end
      end

      def refresh_token_filename
        file_name = "#{base_token_name}.refresh_token"
        @refresh_token_filename ||= File.join(config_directory, file_name)
      end

      def refresh_token
        if defined?(@refresh_token) && !@refresh_token.nil?
          return @refresh_token
        end

        @refresh_token = if File.exist?(refresh_token_filename)
                           cached_refresh_token
                         end
      end

      # @deprecation use access_token instead
      def oauth_token
        debug "WARN: oauth_token is deprecated, use access_token instead"
        access_token
      end

      # We have been told our tokens are bad so we need to correct that
      #
      def reauthenticate
        # Don't hold on to the current access token it's worthless
        flush_access_token!

        renew_tokens

        false # Skip GLI error handling
      end

      # This attempts to renew access (and refresh) tokens for the current
      # configuration based on the current connection.
      #
      # @note Brightbox.config and Api.conn are actually two different worlds and should
      #   be merged (so a configuration holds the current connection)
      #
      def renew_tokens(options = {})
        # This monster is basically a worse version of automatically getting the
        # best grant strategy from our fog service itself.
        #
        # If/when the fog connection is correctly initialised all of this can go
        # because passing all the config and all the cached tokens lets fog do
        # it's thing rather than us trying to micromanage it.
        #
        # The only problem is wanting to send a password but prompting halfway
        # through the process.
        #
        password = options[:password] if options[:password]

        # To prevent refreshing tokens for the wrong client (using client_name
        # is pretty random) we set it specially
        if options[:client_name]
          self.client_name = options[:client_name]
        end

        begin
          if using_application?
            if refresh_token
              begin
                service = update_tokens_with_refresh_token
              rescue Excon::Errors::BadRequest, Excon::Errors::Unauthorized
                service = update_tokens_with_user_credentials
              end
            else
              service = update_tokens_with_user_credentials(password)
            end
          else
            service = update_tokens_with_client_credentials
          end

          new_access_token = service.access_token
          new_refresh_token = service.refresh_token
          update_stored_tokens(new_access_token, new_refresh_token)
        rescue Excon::Errors::BadRequest, Excon::Errors::Unauthorized
          error "ERROR: Unable to reauthenticate!"
        ensure
          debug_tokens
        end
      end

      def update_stored_tokens(new_access_token, new_refresh_token = nil)
        save_access_token(new_access_token)
        save_refresh_token(new_refresh_token) unless new_refresh_token.nil?
        debug_tokens
      end

      private

      # This stores the access token for the Fog service currently in use to
      # authenticate with the API.
      #
      def save_access_token(current_access_token)
        if access_token == current_access_token
          debug "Access token remains #{access_token}"
        else
          @access_token = current_access_token
          debug "Attempting to save new access token: #{current_access_token}"
          debug "In memory access token: #{@access_token}"

          # Save to disk
          persist_token(access_token_filename, current_access_token)

          current_access_token
        end
      end

      # This stores the refresh token for the Fog service currently in use to
      # request a new access token when current one has expired.
      #
      def save_refresh_token(current_token)
        if refresh_token == current_token
          debug "Refresh token remains #{refresh_token}"
        else
          @refresh_token = current_token
          debug "Attempting to save new refresh token: #{current_token}"
          debug "In memory refresh token: #{@refresh_token}"

          # Save to disk
          persist_token(refresh_token_filename, current_token)

          current_token
        end
      end

      # WIP - classic API authentication
      def update_tokens_with_client_credentials
        client = Brightbox::Config::ApiClient.new(selected_config, client_name)

        default_fog_options = client.to_fog
        connection = Fog::Compute.new(default_fog_options)
        begin
          connection.get_access_token!
        rescue Excon::Errors::Unauthorized
          raise Brightbox::Api::ApiError, "Invalid credentials"
        end

        connection
      end

      # WIP - use a refresh token to request new tokens
      def update_tokens_with_refresh_token
        user_application = Brightbox::Config::UserApplication.new(selected_config, client_name)

        fog_options = user_application.to_fog
        # FIXME: UserApplication#to_fog should include refresh token but does not
        # have the correct scope to it
        fog_options.merge!(:brightbox_refresh_token => refresh_token)

        connection = Fog::Compute.new(fog_options)
        # If this goes wrong raise and handle above
        connection.get_access_token!
        connection
      end

      def update_tokens_with_user_credentials(password = nil)
        user_application = Brightbox::Config::UserApplication.new(selected_config, client_name)

        password = discover_password(password: password, expired: true)

        # FIXME: options are required to work
        options = {
          :client_id => client_name,
          :email => selected_config["username"],
          :password => password
        }

        user_application.fetch_refresh_token(options)
      end

      def fetch_refresh_token(options)
        self.client_name = options[:client_id]
        client_config = config[client_name]
        user_application = Brightbox::Config::UserApplication.new(client_config, client_name)
        # replace this portion with code that actually fetches a token
        client_config["refresh_token"] = user_application.fetch_refresh_token(options)
        save_refresh_token
      end

      # Blanks access token in memory and on disk
      def flush_access_token!
        @access_token = nil
      end

      # Saves
      def persist_token(filename, token)
        token = "" if token.nil?
        # Write out a token file for this process
        File.write(filename + ".#{$PID}", token)
        # Move process version into place
        debug "Saving #{token} to #{filename}"
        FileUtils.mv filename + ".#{$PID}", filename
      end

      def cached_access_token
        File.open(access_token_filename, "r") { |fl| fl.read.chomp }
      rescue Errno::ENOENT
        nil
      end

      def cached_refresh_token
        File.open(refresh_token_filename, "r") { |fl| fl.read.chomp }
      rescue Errno::ENOENT
        nil
      end

      def remove_cached_tokens!
        remove_access_token!
        remove_refresh_token!
      end

      def remove_access_token!
        @access_token = nil
        FileUtils.rm(access_token_filename) if File.exist?(access_token_filename)
      end

      def remove_refresh_token!
        @refresh_token = nil
        FileUtils.rm(refresh_token_filename) if File.exist?(refresh_token_filename)
      end

      def base_token_name
        return nil if client_name.nil?

        client_name.gsub("/", "_")
      end
    end
  end
end
