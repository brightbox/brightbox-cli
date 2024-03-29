module Brightbox
  command [:config] do |cmd|
    cmd.desc I18n.t("config.client_default.desc")
    cmd.arg_name "alias"
    cmd.command [:client_default] do |c|
      c.action do |_global_options, _options, args|
        info "Using config file #{Brightbox.config.config_filename}"
        calias = args.shift

        raise "You must specify the api alias you want to set as the default" if calias.nil?
        raise "An api client with the alias #{calias} does not exist in the config" unless Brightbox.config.client_named?(calias)

        info "Setting #{calias} as default api client"
        Brightbox.config.set_default_client(calias)
      end
    end
  end
end
