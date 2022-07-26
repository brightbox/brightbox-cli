module Brightbox
  module Config
    module TwoFactorAuth
      ENTER_TWO_FACTOR_PROMPT = "Enter your two factor pin : ".freeze

      attr_accessor :current_second_factor

      def discover_two_factor_pin
        @two_factor_pin ||= Brightbox.config.two_factor_helper_password
        @two_factor_pin ||= prompt_for_two_factor_pin

        self.current_second_factor = @two_factor_pin
      end

      private

      def two_factor_enabled
        return false unless client_name.nil?
        return true if config[client_name]["two_factor"] == "true"

        false
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
