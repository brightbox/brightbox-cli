module Fog
  module Compute
    class Brightbox
      class Real
        # Lists all collaborations the user is involved with
        #
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_collaboration_list_user_collaborations
        #
        def list_user_collaborations
          request("get", "/1.0/user/collaborations", [200])
        end

      end
    end
  end
end
