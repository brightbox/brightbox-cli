module Brightbox
  class User < Api

    def attributes
      a = fog_model.attributes
      a[:ssh_key_set?] = ssh_key_set?
      a
    end

    def to_row
      attributes.merge({ :accounts => accounts.size })
    end

    def self.all
      conn.users
    end

    def self.get(id)
      conn.users.get id
    end

    def self.default_field_order
      [:id, :name, :email_address, :ssh_key_set?, :accounts]
    end

    def to_s
      @id
    end

    def ssh_key_set?
      !ssh_key.to_s.strip.empty?
    end

    def render_cell
      handle if fog_model
    end
  end
end
