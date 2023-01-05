module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.lock.desc")
    cmd.arg_name I18n.t("volumes.args.many")

    cmd.command [:lock] do |c|
      c.action do |_global_options, _options, args|
        raise I18n.t("volumes.args.specify_many_ids") if args.empty?

        volumes = Volume.find_or_call(args) do |volume|
          raise I18n.t("volumes.args.unknown_id", volume: volume)
        end

        volumes.each do |volume|
          info I18n.t("volumes.lock.acting", volume: volume)
          volume.lock!
        end
      end
    end

    cmd.desc I18n.t("volumes.unlock.desc")
    cmd.arg_name I18n.t("volumes.args.many")

    cmd.command [:unlock] do |c|
      c.action do |_global_options, _options, args|
        raise I18n.t("volumes.args.specify_many_ids") if args.empty?

        volumes = Volume.find_or_call(args) do |volume|
          raise I18n.t("volumes.args.unknown_id", volume: volume)
        end

        volumes.each do |volume|
          info I18n.t("volumes.unlock.acting", volume: volume)
          volume.unlock!
        end
      end
    end
  end
end
