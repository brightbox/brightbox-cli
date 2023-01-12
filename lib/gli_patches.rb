require "gli/dsl"
require "gli/command_line_option"
require "gli/option_parser_factory"

module GLI
  module DSL
    def extract_options(names)
      options = {}
      options = names.pop if names.last.kind_of? Hash
      options = {
        :desc => @next_desc,
        :long_desc => @next_long_desc,
        :default_value => @next_default_value,
        :ignore_default => @ignore_default,
        :arg_name => @next_arg_name
      }.merge(options)
    end
  end

  class CommandLineOption
    def initialize(names, options = {})
      # Disable returning a default for this option (needed for boolean updates)
      # which should NOT be sent unless added by the user
      @ignore_default = !!options[:ignore_default]

      super(names, options[:desc], options[:long_desc])
      @default_value = options[:default_value]
    end

    def ignore_default?
      @ignore_default
    end
  end

  class OptionParserFactory
    private

    def set_defaults(options_by_name,options_hash)
      options_by_name.values.each do |option|
        option.names_and_aliases.each do |option_name|
          [option_name,option_name.to_sym].each do |name|
            next if option.ignore_default?

            options_hash[name] = option.default_value if options_hash[name].nil?
          end
        end
      end
    end
  end
end
