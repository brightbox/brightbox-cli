module Brightbox
  command [:config] do |cmd|

    cmd.desc "Set the default api client in the config"
    cmd.arg_name "alias"
    cmd.command [:client_default] do |c|

      c.action do |global_options, options, args|

        info "Using config file #{$config.config_filename}"
        calias = args.shift

        if calias.nil?
          raise "You must specify the api alias you want to set as the default"
        end

        client_config = $config.clients.detect{|c| $config[c]["alias"] == calias}
        if client_config.nil?
          raise "An api client with the alias #{calias} does not exist in the config"
        end

        info "Setting #{calias} as default api client"
        $config["core"]["default_client"] = client_config
        $config.save!
      end
    end
  end
end
