module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|

      cmd.desc I18n.t("sql.instances.show.desc")
      cmd.arg_name "instance-id..."
      cmd.command [:show] do |c|

        c.action do |global_options, _options, args|

          raise "You must specify instance IDs to show" if args.empty?

          servers = DatabaseServer.find_or_call(args) do |id|
            raise "Couldn't find an SQL instance with ID #{id}"
          end

          table_opts = global_options.merge(
            :vertical => true,
            :fields => DatabaseServer.detailed_fields
          )
          render_table(servers, table_opts)
        end
      end
    end
  end
end
