module Brightbox
  module Config
    module PasswordHelper
      attr_accessor :password_helper_password

      def password_helper_command
        return config[client_name]["password_helper_command"] unless client_name.nil?
      end

      # Return the password from the helper if it's possible
      def password_helper_password
        if defined?(@password_helper_password) && !@password_helper_password.nil?
          return @password_helper_password
        end

        if password_helper_command
          @password_helper_password = password_helper_call
        else
          @password_helper_password = nil
        end
      end

      private

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
    end
  end
end
