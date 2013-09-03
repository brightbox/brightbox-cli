module Brightbox
  module Config
    # The CLI config file is broken into sections, each with a unique name. When
    # adding a new section as a conveinence if a name would clash instead of the
    # original error we select a suitable alternative.
    #
    # If the name is not in use then it is returned unchanged.
    #
    class SectionNameDeduplicator

      # @param [String] name The name to deduplicate
      # @param [Array<String>] in_use The names already in use in the config
      #
      def initialize(name, in_use)
        @name = name
        @in_use = in_use
      end

      # Return the next name given those in use already
      #
      # @return [String]
      def next
        # Sanity check. If the name is not in use, offer it back
        if @in_use.include?(@name)
          existing_matches = @in_use.sort.select do |name|
            name == @name
          end

          "#{normalised_name}_#{next_suffix}"
        else
          @name
        end
      end

    private

      # Returns name with no numerical suffix (_\d+)
      def normalised_name
        /(.*?)(_\d+)?\z/.match(@name).captures.first
      end

      # Find any names in use fitting the name_suffix pattern to determine which
      # suffix values are in use
      def related_names_in_use
        @in_use.map {|n| /\A#{normalised_name}_(\d+)\z/.match(n) }.compact
      end

      # Find the largest number suffix used
      def max_suffix_value
        related_names_in_use.map {|match| match.captures.first.to_i }.max
      end

      # Find and increment the suffix
      def next_suffix
        if max_suffix_value.respond_to?(:next)
          max_suffix_value.next
        else
          # If it's not a number then something is wrong
          1
        end
      end
    end
  end
end
