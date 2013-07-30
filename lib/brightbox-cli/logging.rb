module Brightbox
  module Logging
    def self.included(base)
      base.extend MixinMethods
      base.send(:include, MixinMethods)
    end

    module MixinMethods
      def error(s='')
        $stderr.write s
        $stderr.write "\n"
        $stderr.flush
      end

      def info(s='')
        $stderr.write s
        $stderr.write "\n"
        $stderr.flush
      end

      def warn(s='')
        info "WARN: #{s}"
      end

      def data(s)
        $stdout.write s
        $stdout.write "\n"
      end

      def debug(s)
        if ENV['DEBUG']
          $stderr.write "DEBUG: "
          $stderr.write s
          $stderr.write "\n"
        end
      end
    end
  end
  include Logging
end
