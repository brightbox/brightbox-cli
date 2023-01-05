module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.detach.desc")
    cmd.arg_name I18n.t("volumes.args.many")

    cmd.command [:detach] do |c|
      c.action do |global_options, _options, args|
        raise I18n.t("volumes.args.specify_many_ids") if args.empty?

        volumes = Volume.find_or_call(args) do |volume|
          raise I18n.t("volumes.args.unknown_id", volume: volume)
        end

        volumes.each do |volume|
          info I18n.t("volumes.detach.acting", volume: volume)
          volume.detach
        end

        render_table(volumes, global_options)
      end
    end
  end
end
