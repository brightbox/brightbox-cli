module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.show.desc")
    cmd.arg_name I18n.t("volumes.args.optional")

    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        volumes = Volume.find_all_or_warn(args)

        table_opts = global_options.merge(
          :vertical => true,
          :fields => Volume.detailed_fields
        )
        render_table(volumes, table_opts)
      end
    end
  end
end
