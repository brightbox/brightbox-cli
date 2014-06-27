module Brightbox
  module Config
    # This module holds a very simple set of change / dirty tracking methods to
    # keep track of when the config or any sub part (client config sections)
    # have been changed to prevent excess saving
    #
    module Dirty
      # @return [Boolean] +true+ if config has been modified since loading
      def dirty?
        !!@dirty
      end

      # Mark the config as being dirty
      #
      def dirty!
        @dirty = true
      end

      # Remove that the config is dirty because it has been saved to disk
      #
      def clean_up
        @dirty = false
      end
    end
  end
end
