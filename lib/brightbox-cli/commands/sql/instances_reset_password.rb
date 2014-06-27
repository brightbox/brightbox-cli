module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|

      cmd.desc I18n.t("sql.instances.reset_password.desc")
      cmd.arg_name "server-id"
      cmd.command [:"reset-password"] do |c|
        c.action do |global_options, _options, args|
          dbs_id = args.shift
          unless dbs_id =~ /^dbs-/
            raise "You must specify a valid SQL instance ID as the first argument"
          end

          server = DatabaseServer.find dbs_id

          info "Resetting admin password for #{server}"
          begin
            server.reset_password
          rescue Brightbox::Api::Conflict
            error "Could not reset password for #{server}"
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
