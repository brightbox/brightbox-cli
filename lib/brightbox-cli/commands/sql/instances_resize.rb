module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|
      cmd.desc I18n.t("sql.instances.reset_password.desc")
      cmd.arg_name "server-id"
      cmd.command [:resize] do |c|
        # Database type
        c.desc I18n.t("sql.instances.options.type.desc")
        c.flag %i[t type]

        c.action do |global_options, options, args|
          dbs_id = args.shift

          unless dbs_id =~ /^dbs-/
            raise I18n.t("sql.instances.args.invalid")
          end

          new_type = options[:type]
          unless new_type =~ /^dbt-/
            raise I18n.t("sql.instances.options.type.invalid")
          end

          server = DatabaseServer.find dbs_id

          info I18n.t("sql.instances.resize.acting", database_server: server)
          begin
            server.resize(new_type: new_type)
          rescue Brightbox::Api::Conflict
            error I18n.t("sql.instances.resize.failed", database_server: server)
          end

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
