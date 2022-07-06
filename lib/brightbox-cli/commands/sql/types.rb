module Brightbox
  command [:sql] do |product|
    product.desc I18n.t("sql.types.desc")
    product.command [:types] do |cmd|
      cmd.default_command :list

      cmd.desc I18n.t("sql.types.list.desc")
      cmd.arg_name "[type-id...]"
      cmd.command [:list] do |c|
        c.action do |global_options, _options, args|
          types = if args.empty?
                    DatabaseType.find :all
                  else
                    DatabaseType.find_or_call(args) do |id|
                      warn "Couldn't find an SQL type with ID #{id}"
                    end
                  end

          render_table(types.sort, global_options)
        end
      end

      cmd.desc I18n.t("sql.types.show.desc")
      cmd.arg_name "[type-id...]"
      cmd.command [:show] do |c|
        c.action do |global_options, _options, args|
          if args.empty?
            raise "You must specify the types you want to show"
          end

          types = DatabaseType.find_or_call(args) do |id|
            warn "Couldn't find an SQL type with ID #{id}"
          end

          display_options = {
            :vertical => true,
            :fields => %i[id name description ram disk]
          }

          table_opts = global_options.merge(display_options)
          render_table(types, table_opts)
        end
      end
    end
  end
end
