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

    def self.default_field_order
      [:id, :status, :account, :role]
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

    def to_row
      row_attributes = attributes
      row_attributes[:account] = attributes[:account]["id"]
      row_attributes
    end
  end
end
