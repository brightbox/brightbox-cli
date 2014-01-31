module Brightbox
  # These are collaborations from the perspective of the authenticated account
  # admins. This allows creating new invites, listing, viewing, cancelling or
  # resending emails
  #
  class Collaboration < Api
    def self.require_account?; true; end

    def self.invite(email, role)
      options = { :email => email, :role => role }
      data = conn.create_collaboration(options)
      model = Fog::Compute::Brightbox::Collaboration.new(data)
      new(model)
    end

    def self.all
      conn.collaborations
    end

    def self.get(id)
      conn.collaborations.get(id)
    end

    def self.default_field_order
      [:id, :status, :role, :email, :name]
    end

    def to_s
      @id
    end

    def id
      @id
    end

    def attributes
      fog_model.attributes
    end

    def to_row
      row_attributes = attributes
      row_attributes[:name] = invitee_name
      row_attributes
    end

    def invitee_name
      if attributes[:user].nil?
        "-"
      else
        attributes[:user]["name"]
      end
    end

    def resend
      data = service.resend_collaboration(id)
      fog_model.merge_attributes(data)
    end
  end
end
