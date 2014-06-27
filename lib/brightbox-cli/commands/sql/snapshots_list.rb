module Brightbox
  command [:sql] do |product|
    product.command [:snapshots] do |cmd|

      cmd.default_command :list

      cmd.desc I18n.t("sql.snapshots.list.desc")
      cmd.arg_name "[snapshot-id...]"
      cmd.command [:list] do |c|

        c.action do |global_options, _options, args|
          if args.empty?
            snapshots = DatabaseSnapshot.find(:all)
          else
            snapshots = DatabaseSnapshot.find_or_call(args) do |id|
              warn "Couldn't find snapshot #{id}"
            end
          end

          render_table(snapshots, global_options)
        end
      end
    end
  end
end
