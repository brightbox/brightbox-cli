module Brightbox
  module Config
    module GpgEncryptedPasswords
      attr_accessor :gpg_password

      def gpg_encrypted_password_filename
        file_name = "#{client_name}.password.gpg"
        @gpg_encrypted_password_filename ||= File.join(config_directory, file_name)
      end

      # Return the password from gpg if it's possible
      def gpg_password
        if defined?(@gpg_password) && !@gpg_password.nil?
          return @gpg_password
        end
        if File.exist?(gpg_encrypted_password_filename)
          @gpg_password = gpg_decrypt_password
        else
          @gpg_password = nil
        end
      end

      private

      # Use gpg to decrypt the password
      def gpg_decrypt_password
        info "INFO: Decrypting #{gpg_encrypted_password_filename} to obtain password"
        begin
          IO::popen(["gpg", "--decrypt", gpg_encrypted_password_filename], "r") do |io|
            io.read.chomp
          end
        rescue Errno::ENOENT
          nil
        end
      end

    end
  end
end
