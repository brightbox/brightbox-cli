module Brightbox
  command [:config] do |cmd|

    cmd.desc I18n.t("config.client_default.desc")
    cmd.arg_name "alias"
    cmd.command [:client_default] do |c|

      c.action do |global_options, options, args|

        info "Using config file #{$config.config_filename}"
        calias = args.shift

        if calias.nil?
          raise "You must specify the api alias you want to set as the default"
        end

        if $config.client_named?(calias)
          info "Setting #{calias} as default api client"
          $config.set_default_client(calias)
        else
          raise "An api client with the alias #{calias} does not exist in the config"
        end
      end
    end
  end
end
