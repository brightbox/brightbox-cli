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

        # Maintenance window options
        c.desc I18n.t("sql.instances.options.maintenance_weekday.desc")
        c.flag ["maintenance-weekday"]
        c.desc I18n.t("sql.instances.options.maintenance_hour.desc")
        c.flag ["maintenance-hour"]

        # Snapshot
        c.desc I18n.t("sql.instances.options.snapshot.desc")
        c.flag [:snapshot]

        # Zone
        c.desc I18n.t("sql.instances.options.zone.desc")
        c.flag [:z, "zone"]

        c.action do |global_options, options, args|
          params = DatabaseServer.clean_arguments(options)

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
