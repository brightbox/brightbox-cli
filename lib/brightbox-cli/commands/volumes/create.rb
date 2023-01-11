module Brightbox
  command [:volumes] do |cmd|
    cmd.desc I18n.t("volumes.create.desc")

    cmd.command [:create] do |c|
      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.desc I18n.t("volumes.options.delete_with_server")
      c.default_value false
      c.switch ["delete-with-server"], negatable: true

      c.desc I18n.t("volumes.options.encrypted")
      c.switch %i[e encrypted], negatable: true

      c.desc I18n.t("volumes.options.fs_label")
      c.flag ["fs-label"]

      c.desc I18n.t("volumes.options.fs_type")
      c.flag ["fs-type"]

      c.desc I18n.t("volumes.options.image")
      c.flag %i[i image]

      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("volumes.options.serial")
      c.flag [:serial]

      c.desc I18n.t("volumes.options.size")
      c.flag %i[s size]

      c.action do |global_options, options, _args|
        if options[:image].nil? && options[:"fs-type"].nil?
          raise I18n.t("volumes.create.image_or_type_required")
        end

        if !options[:image].nil? && !options[:"fs-type"].nil?
          raise I18n.t("volumes.create.either_image_or_type")
        end

        params = {
          delete_with_server: options[:"delete-with-server"],
          encrypted: options[:encrypted]
        }

        params[:filesystem_label] = options[:"fs-label"] if options[:"fs-label"]
        params[:filesystem_type] = options[:"fs-type"] if options[:"fs-type"]
        params[:image_id] = options[:image] if options[:image]

        params[:description] = options[:description] if options[:description]
        params[:name] = options[:name] if options[:name]
        params[:serial] = options[:serial] if options[:serial]
        params[:size] = options[:size] if options[:size]

        info I18n.t("volumes.create.acting")
        volume = Volume.create(params)
        render_table([volume], global_options)
      end
    end
  end
end
