module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.copy.desc")
    cmd.arg_name I18n.t("volumes.args.one")

    cmd.command [:copy] do |c|
      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.desc I18n.t("volumes.options.delete_with_server")
      c.default_value false
      c.switch ["delete-with-server"], negatable: true

      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("volumes.options.serial")
      c.flag [:serial]

      c.action do |global_options, options, args|
        vol_id = args.shift

        if vol_id.nil? || !vol_id.start_with?("vol-")
          raise I18n.t("volumes.args.specify_one_id_first")
        end

        params = {
          delete_with_server: options["delete-with-server"]
        }
        params[:description] = options[:description] if options[:description]
        params[:name] = options[:name] if options[:name]
        params[:serial] = options[:serial] if options[:serial]

        volume = Volume.find(vol_id)

        unless params.empty?
          info I18n.t("volumes.copy.acting", volume: volume)
          volume.copy(params)
        end

        render_table([volume], global_options)
      end
    end
  end
end
