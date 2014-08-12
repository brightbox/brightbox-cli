module Brightbox
  class DatabaseServer < Api
    def self.require_account?
      true
    end

    def self.create(options)
      new(conn.database_servers.create(options))
    end

    def self.all
      conn.database_servers.all
    end

    def self.get(id)
      conn.database_servers.get(id)
    end

    def update(options)
      self.class.conn.update_database_server(id, options)
      reload
      self
    end

    def reset_password
      fog_model.reset_password
    end

    def destroy
      fog_model.destroy
    end

    def self.default_field_order
      [
        :id,
        :status,
        :type,
        :db_engine,
        :zone,
        :created_on,
        :cloud_ip_ids,
        :name
      ]
    end

    # These are all the fields show in the longer table form
    def self.detailed_fields
      [
        :id, :name, :description, :status, :locked,
        :type, :engine, :version,
        :zone,
        :created_on,
        :admin_username, :admin_password,
        :allow_access,
        :cloud_ip_ids, :cloud_ips
      ]
    end

    def type_identifier
      if fog_model.attributes.key?("database_server_type")
        fog_model.attributes["database_server_type"]["id"]
      end
    end

    def zone_handle
      if fog_model.attributes.key?("zone")
        fog_model.attributes["zone"]["handle"]
      end
    end

    def to_row
      a = fog_model.attributes
      a[:status] = fog_model.state
      a[:locked] = locked?
      a[:type] = type_identifier
      a[:db_engine] = engine_version
      a[:engine] = database_engine
      a[:version] = database_version
      a[:zone] = zone_handle
      a[:created_on] = created_on
      a[:allow_access] = allow_access
      a[:cloud_ip_ids] = cloud_ip_ids
      a[:cloud_ips] = cloud_ip_addresses
      a
    end

    def engine_version
      [database_engine, database_version].join("-")
    end

    # Lists the CIP identifiers (cip-12345)
    def cloud_ip_ids
      cloud_ips.map { |cip| cip["id"] }
    end

    # Lists the CIP IP addresses
    def cloud_ip_addresses
      cloud_ips.map { |cip| cip["public_ip"] }
    end
  end
end
