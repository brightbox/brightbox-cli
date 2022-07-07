module Brightbox
  module Logging
    def self.included(base)
      base.extend MixinMethods
      base.send(:include, MixinMethods)
    end

    module MixinMethods
      def error(log_msg = "")
        $stderr.write log_msg
        $stderr.write "\n"
        $stderr.flush
      end

      def info(log_msg = "")
        $stderr.write log_msg
        $stderr.write "\n"
        $stderr.flush
      end

      def warn(log_msg = "")
        info "WARN: #{log_msg}"
      end

      def data(log_msg)
        $stdout.write log_msg
        $stdout.write "\n"
      end

      def debug(log_msg)
        return unless ENV["DEBUG"]

        $stderr.write "DEBUG: "
        $stderr.write log_msg
        $stderr.write "\n"
      end
    end
  end
  include Logging
end
