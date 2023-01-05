module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.destroy.desc")
    cmd.arg_name I18n.t("volumes.args.many")

    cmd.command [:destroy] do |c|
      c.action do |_global_options, _options, args|
        raise I18n.t("volumes.args.specify_many_ids") if args.empty?

        volumes = Volume.find_or_call(args) do |id|
          raise I18n.t("volumes.args.unknown_id", volume: volume)
        end

        volumes.each do |volume|
          info I18n.t("volumes.destroy.acting", volume: volume)

          begin
            volume.destroy
          rescue Brightbox::Api::Conflict
            error "Could not destroy #{id}"
          end
        end
      end
    end
  end
end
