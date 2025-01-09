module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.show.desc")
    cmd.arg_name I18n.t("volumes.args.optional")

    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        raise "You must specify volume IDs to show" if args.empty?

        volumes = Volume.find_or_call(args) do |id|
          raise "Couldn't find a volume with ID #{id}"
        end

        table_opts = global_options.merge(
          :vertical => true,
          :fields => Volume.detailed_fields
        )
        render_table(volumes, table_opts)
      end
    end
  end
end
