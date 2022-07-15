module Brightbox
  module Config
    module PasswordHelper
      ENTER_PASSWORD_PROMPT = "Enter your password : ".freeze
      EXPIRED_TOKEN_PROMPT = "Your API credentials have expired, enter your password to update them.".freeze

      attr_writer :password_helper_password

      # {discover_password} will return the first password that can be
      # recovered from either the passed input, encrypted storage, a
      # helper application (if configured) or finally promping.
      #
      # @param password [String] a password given to the method
      # @param expired [Boolean] should the prompt explain tokens have expired?
      # @return [String] the password
      #
      def discover_password(password: nil, expired: false)
        password ||= gpg_password
        password ||= password_helper_password
        password ||= prompt_for_password(expired)

        # Current workaround for 2FA support is to check for config and
        # append OTP to password
        extend_with_two_factor_pin(password)
      end

      private

      def password_helper_command
        return config[client_name]["password_helper_command"] unless client_name.nil?
      end

      # Return the password from the helper if it's possible
      def password_helper_password
        if defined?(@password_helper_password) && !@password_helper_password.nil?
          return @password_helper_password
        end

        @password_helper_password = if password_helper_command
                                      password_helper_call
                                    end
      end

      def password_helper_call
        info "INFO: Calling password helper to obtain password"
        begin
          cmd = password_helper_command.split(/\s+/)
          IO.popen(cmd, "r") do |io|
            io.readline.chomp
          end
        rescue Errno::ENOENT
          nil
        end
      end

      # This asks the user to input their password
      def prompt_for_password(expired)
        require "highline"
        highline = HighLine.new
        highline.say(EXPIRED_TOKEN_PROMPT) if expired

        # FIXME: Capture interupts if user aborts
        highline.ask(ENTER_PASSWORD_PROMPT) { |q| q.echo = false }
      end
    end
  end
end
