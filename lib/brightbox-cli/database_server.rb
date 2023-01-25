require "date"

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

    def reset
      fog_model.reset
    end

    def reset_password
      fog_model.reset_password
    end

    def resize(options)
      fog_model.resize(options[:new_type])
    end

    def destroy
      fog_model.destroy
    end

    def self.default_field_order
      %i[
        id
        status
        type
        db_engine
        zone
        created_on
        cloud_ip_ids
        name
      ]
    end

    # These are all the fields show in the longer table form
    def self.detailed_fields
      %i[
        id name description status locked
        type engine version
        zone
        created_on
        admin_username admin_password
        maintenance_window
        snapshots_schedule
        snapshots_schedule_next_at
        allow_access
        cloud_ip_ids cloud_ips
      ]
    end

    def type_identifier
      return unless fog_model.attributes.key?("database_server_type")

      fog_model.attributes["database_server_type"]["id"]
    end

    def zone_handle
      return unless fog_model.attributes.key?("zone")

      fog_model.attributes["zone"]["handle"]
    end

    def to_row
      a = fog_model.attributes
      a[:status] = fog_model.state
      a[:locked] = locked?
      a[:type] = type_identifier
      a[:db_engine] = engine_version
      a[:engine] = database_engine
      a[:version] = database_version
      a[:maintenance_weekday] = maintenance_weekday
      a[:maintenance_hour] = maintenance_hour
      a[:maintenance_window] = maintenance_window
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

    # A more humanised version of the maintenance window
    def maintenance_window
      return nil if maintenance_weekday.nil?

      weekday = Date::DAYNAMES[maintenance_weekday]
      format("%s %02d:00 UTC", weekday, maintenance_hour)
    end

    def cloud_ips
      super.nil? ? [] : super
    end

    # Lists the CIP identifiers (cip-12345)
    def cloud_ip_ids
      cloud_ips.map { |cip| cip["id"] }
    end

    # Lists the CIP IP addresses
    def cloud_ip_addresses
      cloud_ips.map { |cip| cip["public_ip"] }
    end

    # Converts GLI's arguments to fog based parameters
    def self.clean_arguments(args)
      params = NilableHash.new

      params[:name] = args[:n] if args[:n]
      params[:description] = args[:d] if args[:d]

      if args["allow-access"]
        params[:allow_access] = args["allow-access"].split(",")
      end

      if args["maintenance-weekday"]
        params[:maintenance_weekday] = weekday_index(args["maintenance-weekday"])
      end
      params[:maintenance_hour] = args["maintenance-hour"] if args["maintenance-hour"]

      params[:snapshots_schedule] = args["snapshots-schedule"] if args["snapshots-schedule"]
      if args["remove-snapshots-schedule"]
        params[:snapshots_schedule] = nil
      end

      params[:database_engine] = args[:engine] if args[:engine]
      params[:database_version] = args["engine-version"] if args["engine-version"]

      params[:snapshot_id] = args[:snapshot] if args[:snapshot]
      params[:flavor_id] = args[:type] if args[:type]
      params[:zone_id] = args[:zone] if args[:zone]

      params.nilify_blanks
      params
    end

    # @param [String] user_input either a day or it's index ('sunday' or '0')
    # @returns [String] The index
    def self.weekday_index(user_input)
      DateTime.parse(user_input).wday.to_s
    rescue ArgumentError
      user_input.to_s
    end
  end
end
