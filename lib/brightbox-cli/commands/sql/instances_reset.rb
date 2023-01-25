module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|
      cmd.desc I18n.t("sql.instances.reset_password.desc")
      cmd.arg_name "server-id"
      cmd.command [:reset] do |c|
        c.action do |global_options, _options, args|
          dbs_id = args.shift

          unless dbs_id =~ /^dbs-/
            raise I18n.t("sql.instances.args.invalid")
          end

          server = DatabaseServer.find dbs_id

          info I18n.t("sql.instances.reset.acting", database_server: server)
          begin
            server.reset
          rescue Brightbox::Api::Conflict
            error I18n.t("sql.instances.reset.failed", database_server: server)
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
