module Fog
  module Compute
    class Brightbox
      class Real
        # Ends an existing 'accepted' collaboration
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_delete_user_collaboration
        #
        def delete_user_collaboration(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/user/collaborations/#{identifier}", [200])
        end

      end
    end
  end
end
