module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.attach.desc")
    cmd.arg_name I18n.t("volumes.attach.args")

    cmd.command [:attach] do |c|
      c.desc I18n.t("volumes.options.boot")
      c.default_value false
      c.switch [:boot], negatable: true

      c.action do |global_options, options, args|
        vol_id = args.shift

        if vol_id.nil? || !vol_id.start_with?("vol-")
          raise I18n.t("volumes.args.specify_one_id_first")
        end

        srv_id = args.shift

        if srv_id.nil? || !srv_id.start_with?("srv-")
          raise I18n.t("volumes.attach.specify_server_id_second")
        end

        boot_flag = options[:boot]

        volume = Volume.find(vol_id)

        info I18n.t("volumes.attach.acting", volume: volume)
        volume.attach(server: srv_id, boot: boot_flag)
        volume.reload

        render_table([volume], global_options)
      end
    end
  end
end
