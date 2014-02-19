module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|

      cmd.desc I18n.t("sql.instances.update.desc")
      cmd.arg_name "instance-id"
      cmd.command [:update] do |c|

        c.desc I18n.t("options.name.desc")
        c.flag [:n, :name]

        c.desc I18n.t("options.description.desc")
        c.flag [:d, "description"]

        c.desc I18n.t("sql.instances.options.allow_access.desc")
        c.flag [:"allow-access"]

        # Maintenance window options
        c.desc I18n.t("sql.instances.options.maintenance_weekday.desc")
        c.flag ["maintenance-weekday"]
        c.desc I18n.t("sql.instances.options.maintenance_hour.desc")
        c.flag ["maintenance-hour"]

        c.desc I18n.t("sql.instances.options.default_maintenance.desc")
        c.switch ["default-maintenance"], :negatable => false

        c.action do |global_options, options, args|
          dbs_id = args.shift
          unless dbs_id =~ /^dbs-/
            raise "You must specify a valid SQL instance ID as the first argument"
          end

          server = DatabaseServer.find dbs_id
          params = DatabaseServer.clean_arguments(options)

          info "Updating #{server}"
          server.update params
          server.reload
          render_table([server], global_options)
        end
      end
    end
  end
end
