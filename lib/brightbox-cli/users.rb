module Brightbox
  class User < Api

    def attributes
      fog_model.attributes
    end

    def to_row
      attributes.merge({ :accounts => accounts.size })
    end

    def self.all
      conn.users
    end

    def self.get(id)
      u = conn.users.get id
      (u.nil? or u.id != id) ? nil : u
    end

    def self.default_field_order
      [:id, :name, :email_address, :accounts]
    end

    def accounts
      @accounts ||= fog_model.accounts.collect { |a| Account.new(a["id"]) }
    end

    def to_s
      @id
    end

    def save
      fog_model.save
    end

    def ssh_key_set?
      !ssh_key.to_s.strip.empty?
    end

    def render_cell
      handle if fog_model
    end
  end
end
