module Brightbox
  module Config
    module TwoFactorAuth

      def extend_with_two_factor_pin(password)
        if two_factor_enabled
          suffix = "+" + two_factor_pin
          password += suffix unless password.end_with?(suffix)
        end
        password
      end

      private

      def two_factor_enabled
        return config[client_name]["two_factor"] == "true" unless client_name.nil?
      end

      def two_factor_pin
        @two_factor_pin ||= prompt_for_two_factor_pin if two_factor_enabled
      end

      def prompt_for_two_factor_pin
        require "highline"
        highline = HighLine.new
        # FIXME: Capture interupts if user aborts
        highline.ask("Enter your two factor pin : ")
      end
    end
  end
end
