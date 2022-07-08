module Brightbox
  command [:sql] do |product|
    product.command [:snapshots] do |cmd|
      cmd.desc I18n.t("sql.snapshots.show.desc")
      cmd.arg_name "[snapshot-id...]"
      cmd.command [:show] do |c|
        c.action do |global_options, _options, args|
          raise "You must specify snapshot ids to show" if args.empty?

          servers = DatabaseSnapshot.find_or_call(args) do |id|
            raise "Couldn't find snapshot #{id}"
          end

          table_opts = global_options.merge(
            :vertical => true,
            :fields => %i[
              id
              name
              description
              status
              database_engine
              database_version
              locked
              created_on
              created_at
              size
              source
            ]
          )
          render_table(servers, table_opts)
        end
      end
    end
  end
end
