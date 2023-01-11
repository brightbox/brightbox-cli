module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.resize.desc")
    cmd.arg_name I18n.t("volumes.args.one")

    cmd.command [:resize] do |c|
      c.desc I18n.t("volumes.options.size")
      c.flag %i[s size]

      c.action do |global_options, options, args|
        vol_id = args.shift

        if vol_id.nil? || !vol_id.start_with?("vol-")
          raise I18n.t("volumes.args.specify_one_id_first")
        end

        if options[:size].nil?
          raise I18n.t("volumes.resize.size_option_needed")
        end

        new_size = options[:size].to_i

        volume = Volume.find(vol_id)
        old_size = volume.size

        info I18n.t("volumes.resize.acting", volume: volume)
        volume.resize(
          from: old_size,
          to: new_size
        )

        render_table([volume], global_options)
      end
    end
  end
end
