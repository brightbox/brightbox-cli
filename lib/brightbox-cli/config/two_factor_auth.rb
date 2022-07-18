module Brightbox
  module Config
    module TwoFactorAuth
      ENTER_TWO_FACTOR_PROMPT = "Enter your two factor pin : ".freeze

      attr_accessor :current_second_factor

      def discover_two_factor_pin
        return unless two_factor_enabled

        @two_factor_pin ||= Brightbox.config.two_factor_helper_password
        @two_factor_pin ||= prompt_for_two_factor_pin
      end

      def extend_with_two_factor_pin(password)
        return password unless two_factor_enabled

        # Make the OTP available in the configuration
        self.current_second_factor = discover_two_factor_pin
        return password unless current_second_factor

        # This is a workaround to send the OTP appended to password
        suffix = "+#{current_second_factor}"
        password += suffix unless password.end_with?(suffix)
        password
      end

      private

      def two_factor_enabled
        return config[client_name]["two_factor"] == "true" unless client_name.nil?
      end

      def prompt_for_two_factor_pin
        require "highline"
        highline = HighLine.new
        # FIXME: Capture interupts if user aborts
        highline.ask(ENTER_TWO_FACTOR_PROMPT)
      end
    end
  end
end
