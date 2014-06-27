module Brightbox
  desc I18n.t("sql.desc")
  command [:sql] do |product|

    product.desc I18n.t("sql.instances.desc")
    product.command [:instances] do |cmd|

      cmd.desc I18n.t("sql.instances.create.desc")
      cmd.command [:create] do |c|

        c.desc I18n.t("options.name.desc")
        c.flag [:n, :name]

        c.desc I18n.t("options.description.desc")
        c.flag [:d, "description"]

        c.desc I18n.t("sql.instances.options.allow_access.desc")
        c.flag [:"allow-access"]

        # Database type
        c.desc I18n.t("sql.instances.options.type.desc")
        c.flag [:t, :type]

        # Database Engine / Version (e.g. "mysql-5.6"
        c.desc I18n.t("sql.instances.options.engine.desc")
        c.flag [:engine]
        c.desc I18n.t("sql.instances.options.engine_version.desc")
        c.flag ["engine-version"]

        # Snapshot
        c.desc I18n.t("sql.instances.options.snapshot.desc")
        c.flag [:snapshot]

        # Zone
        c.desc I18n.t("sql.instances.options.zone.desc")
        c.flag [:z, "zone"]

        c.action do |global_options, options, _args|
          params = {}

          params[:name] = options[:n] if options[:n]
          params[:description] = options[:d] if options[:d]

          if options[:"allow-access"]
            access_items = options[:"allow-access"].split(",")
            params[:allow_access] = access_items
          end

          params[:database_engine] = options[:engine] if options[:engine]
          params[:database_version] = options["engine-version"] if options["engine-version"]
          params[:snapshot_id] = options[:snapshot] if options[:snapshot]
          params[:flavor_id] = options[:type] if options[:type]
          params[:zone_id] = options[:zone] if options[:zone]

          server = DatabaseServer.create(params)
          table_options = global_options.merge(
            :vertical => true,
            :fields => DatabaseServer.detailed_fields
          )

          render_table([server], table_options)
        end
      end
    end
  end
end
