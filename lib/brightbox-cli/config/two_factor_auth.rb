module Brightbox
  module Config
    module TwoFactorAuth

      def two_factor_enabled
        return config[client_name]["two_factor"] == "true" unless client_name.nil?
      end

      # Return the password from gpg if it's possible
      def two_factor_pin
        prompt_for_two_factor_pin if two_factor_enabled
      end

      private

      def prompt_for_two_factor_pin
        require "highline"
        highline = HighLine.new
        # FIXME: Capture interupts if user aborts
        highline.ask("Enter your two factor pin : ")
      end
    end
  end
end
