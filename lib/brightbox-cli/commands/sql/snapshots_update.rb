module Brightbox
  command [:sql] do |product|
    product.command [:snapshots] do |cmd|

      cmd.desc I18n.t("sql.snapshots.update.desc")
      cmd.arg_name "snapshot-id"
      cmd.command [:update] do |c|

        c.desc I18n.t("options.name.desc")
        c.flag [:n, :name]

        c.desc I18n.t("options.description.desc")
        c.flag [:d, "description"]

        c.action do |global_options, options, args|
          snapshot_id = args.shift
          unless snapshot_id =~ /^dbi-/
            raise "You must specify a valid snapshot id as the first argument"
          end

          snapshot = DatabaseSnapshot.find snapshot_id

          params = NilableHash.new
          params[:name] = options[:n] if options[:n]
          params[:description] = options[:d] if options[:d]

          params.nilify_blanks

          info "Updating #{snapshot}"
          snapshot.update params
          snapshot.reload
          render_table([snapshot], global_options)
        end
      end
    end
  end
end
