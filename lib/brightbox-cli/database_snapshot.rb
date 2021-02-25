module Brightbox
  class DatabaseSnapshot < Api
    def self.require_account?
      true
    end

    def self.all
      conn.database_snapshots.all
    end

    def self.get(id)
      conn.database_snapshots.get(id)
    end

    def update(options)
      self.class.conn.update_database_snapshot(id, options)
      reload
      self
    end

    def destroy
      fog_model.destroy
    end

    def self.default_field_order
      [:id, :status, :created_on, :size, :name]
    end

    def to_row
      a = fog_model.attributes
      a[:status] = fog_model.state
      a[:locked] = locked?
      a[:created_on] = fog_model.created_at.strftime("%Y-%m-%d")
      a
    end
  end
end
