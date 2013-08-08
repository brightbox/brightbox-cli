require "optparse"

module Brightbox
  module Legacy

    # This is a simple class to take the ARGV array and inject a command in the
    # correct position (after global options but before anything else)
    #
    class ArgsAdjuster
      def initialize(args)
        @args = args
      end

      # @param [String] command The command is insert
      # @return [Array<String>]
      def for_command(command)
        @globals = []

        parser = OptionParser.new do |opts|
          opts.on("-v", "--version") {|op| @globals << "-v" }
          opts.on("-s", "--simple") {|op| @globals << "-s" }
          opts.on("-k", "--insecure") {|op| @globals << "-k" }
          opts.on("-c", "--client CLIENT") {|op| @globals << "-c" << op }
          opts.on("--account ACCOUNT") {|op| @globals << "--account" << op }
        end

        remaining = parser.order(@args)

        [] + @globals + [command] + remaining
      end
    end
  end
end
