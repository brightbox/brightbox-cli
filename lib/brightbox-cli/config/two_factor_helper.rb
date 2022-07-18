module Brightbox
  module Config
    module TwoFactorHelper
      attr_writer :two_factor_helper_password

      def two_factor_helper_command
        return config[client_name]["two_factor_helper_command"] unless client_name.nil?
      end

      # Return the two_factor code from the helper if it's possible
      def two_factor_helper_password
        if defined?(@two_factor_helper_password) && !@two_factor_helper_password.nil?
          return @two_factor_helper_password
        end

        @two_factor_helper_password = if two_factor_helper_command
                                        two_factor_helper_call
                                      end
      end

      private

      def two_factor_helper_call
        info "INFO: Calling two factor helper to obtain two factor"
        begin
          cmd = two_factor_helper_command.split(/\s+/)
          IO.popen(cmd, "r") do |io|
            io.readline.chomp
          end
        rescue ArgumentError, Errno::ENOENT
          nil
        end
      end
    end
  end
end
