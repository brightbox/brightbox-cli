module Brightbox
  # These are collaborations from the perspective of the invited user so all
  # that is expected is listing, getting details, accepting, rejecting and
  # destroying them.
  #
  class UserCollaboration < Api
    def self.all
      conn.user_collaborations
    end

    def self.get(id)
      conn.user_collaborations.get(id)
    end

    # This returns the OPEN collaboration based on an account ID to work in with
    # the UI.
    #
    # @todo Ensure filtering works when many collaborations exist between
    #   accounts, and correct states are honoured.
    #
    # @param [String] account_id The identifier of the account
    # @return [Brightbox::UserCollaboration] if a valid collaboration is found
    # @return [NilClass] if no collaboration exists for account
    #
    def self.get_for_account(account_id)
      collaborations = conn.user_collaborations
      open_collaborations = collaborations.select { |col| %w[pending accepted].include?(col.status) }
      collaboration = open_collaborations.find do |col|
        col.account_id == account_id
      end

      return unless collaboration

      new(collaboration)
    end

    def self.default_field_order
      %i[id status account role]
    end

    def to_s
      @id
    end

    # Accepts the collaboration request
    def accept
      fog_model.accept
    end

    # Rejects the collaboration request
    def reject
      fog_model.reject
    end

    def destroy
      fog_model.destroy
    end

    # "removes" the invite by either rejecting or ending it based on the state
    # of the collaboration
    def remove
      if status == "pending"
        reject
      else
        destroy
      end
    end

    def to_row
      row_attributes = attributes
      row_attributes[:account] = attributes[:account]["id"]
      row_attributes.to_h
    end
  end
end
