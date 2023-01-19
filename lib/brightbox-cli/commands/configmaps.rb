module Brightbox
  desc I18n.t("configmaps.desc")
  command [:configmaps] do |cmd|
    cmd.default_command :list

    cmd.desc I18n.t("configmaps.create.desc")
    cmd.arg_name I18n.t("configmaps.args.one")
    cmd.command [:create] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("configmaps.options.data_string")
      c.flag %i[d data]

      c.desc I18n.t("configmaps.options.data_file")
      c.flag [:"data-file"]

      c.action do |global_options, options, _args|
        map_data = parse_configmap_data_options(options)

        raise I18n.t("configmaps.create.data_required") if map_data.nil?

        # Attempt to parse data as JSON but do not update
        begin
          JSON.parse(map_data)
        rescue StandardError
          raise I18n.t("configmaps.options.bad_data")
        end

        params = {
          data: map_data
        }
        params[:name] = options[:name] if options[:name]

        info I18n.t("configmaps.create.acting")
        config_map = ConfigMap.create(params)

        render_table([config_map], global_options)
      end
    end

    cmd.desc I18n.t("configmaps.destroy.desc")
    cmd.arg_name I18n.t("configmaps.args.many")
    cmd.command [:destroy] do |c|
      c.action do |_global_options, _options, args|
        raise I18n.t("configmaps.args.specify_many_ids") if args.empty?

        config_maps = ConfigMap.find_or_call(args) do |id|
          raise I18n.t("configmaps.args.unknown_id", config_map: id)
        end

        config_maps.each do |config_map|
          info I18n.t("configmaps.destroy.acting", config_map: config_map)

          begin
            config_map.destroy
          rescue Brightbox::Api::Conflict
            error I18n.t("configmaps.destroy.failed", config_map: id)
          end
        end
      end
    end

    cmd.desc I18n.t("configmaps.list.desc")
    cmd.arg_name I18n.t("configmaps.args.optional")
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        config_maps = ConfigMap.find_all_or_warn(args)

        render_table(config_maps, global_options)
      end
    end

    cmd.desc I18n.t("configmaps.show.desc")
    cmd.arg_name I18n.t("configmaps.args.optional")
    cmd.command [:show] do |c|
      c.desc I18n.t("configmaps.options.data_output")
      c.switch [:data], negatable: false, default: false

      c.desc I18n.t("configmaps.options.data_format")
      c.flag [:format]

      c.action do |global_options, options, args|
        if options[:data]
          unless args.length == 1
            raise I18n.t("configmaps.options.data_args")
          end

          cfg_id = args[0]

          if cfg_id.nil? || !cfg_id.start_with?("cfg-")
            raise I18n.t("configmaps.args.specify_one_id_first")
          end

          config_map = ConfigMap.find(cfg_id)
          data(config_map.format_data(options[:format] || "json"))
        else
          if options[:format] && !options[:data]
            raise I18n.t("configmaps.options.format_no_data")
          end

          config_maps = ConfigMap.find_all_or_warn(args)

          table_opts = global_options.merge(
            vertical: true
          )
          render_table(config_maps, table_opts)
        end
      end
    end

    cmd.desc I18n.t("configmaps.update.desc")
    cmd.arg_name I18n.t("configmaps.args.one")
    cmd.command [:update] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("configmaps.options.data_string")
      c.flag %i[d data]

      c.desc I18n.t("configmaps.options.data_file")
      c.flag [:"data-file"]

      c.action do |global_options, options, args|
        cfg_id = args[0]

        if cfg_id.nil? || !cfg_id.start_with?("cfg-")
          raise I18n.t("configmaps.args.specify_one_id_first")
        end

        params = {}
        params[:name] = options[:name] if options[:name]

        map_data = parse_configmap_data_options(options)

        if map_data
          begin
            map_data = JSON.parse(map_data)
          rescue StandardError
            raise I18n.t("configmaps.options.bad_data")
          end

          params[:data] = map_data
        end

        config_map = ConfigMap.find(cfg_id)

        unless params.empty?
          info I18n.t("configmaps.update.acting", config_map: config_map)
          config_map.update(params)
        end

        render_table([config_map], global_options)
      end
    end
  end

  def parse_configmap_data_options(options)
    if options[:data] && options[:"data-file"]
      raise I18n.t("configmaps.options.multiple_data")
    end

    map_data = options[:data]
    data_filename = options[:"data-file"]

    if data_filename
      file_handler = lambda do |file|
        map_data = file.read
      end

      if data_filename == "-"
        file_handler[$stdin]
      else
        File.open(data_filename, "r", &file_handler)
      end

      raise map_data.inspect if map_data.nil? || map_data == ""
    end

    map_data
  end
  module_function :parse_configmap_data_options
end
