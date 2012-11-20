module Fog
  module Compute
    class Brightbox
      class Real
        # Cancels or completes the collaboration
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#collaboration_destroy_collaboration
        #
        def destroy_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/collaborations/#{identifier}", [200])
        end

      end
    end
  end
end
