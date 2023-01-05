module Brightbox
  command [:volumes] do |cmd|
    cmd.default_command :list

    cmd.desc I18n.t("volumes.list.desc")
    cmd.arg_name I18n.t("volumes.args.optional")

    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        volumes = Volume.find_all_or_warn(args)

        render_table(volumes, global_options)
      end
    end
  end
end
