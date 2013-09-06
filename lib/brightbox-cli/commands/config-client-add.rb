module Brightbox
  desc "Manages local configuration settings and credentials"
  command [:config] do |cmd|

    cmd.desc "Add new api client details to config"
    cmd.arg_name "client-id secret [api_url, auth_url]"
    cmd.command [:client_add] do |c|

      c.desc "api client alias, for local reference (defaults to client-id)"
      c.flag [:a, "alias"]

      c.desc "auth url"
      c.flag [:t, "auth-url"]

      c.action do |global_options, options, args|

        info "Using config file #{$config.config_filename}"

        client_id = args.shift
        secret = args.shift
        api_url = args.shift || "https://api.gb1.brightbox.com"
        auth_url = args.shift || api_url
        calias = options[:a] || client_id

        if client_id.nil?
          raise "You must specify the api client-id"
        end

        unless client_id[/^cli-.{5}$/]
          raise "The client-id '#{client_id}' must match the format cli-xxxxx"
        end

        if secret.nil?
          raise "You must specify the api secret"
        end

        client_config = $config[calias]
        unless client_config.empty?
          raise "An api client with the id or alias #{calias} already exists"
        end

        info "Creating new api client config #{calias}"

        client_config["alias"] = calias
        client_config["client_id"] = client_id
        client_config["secret"] = secret
        client_config["api_url"] = api_url
        client_config["auth_url"] = auth_url

        $config.write_config_file
        # FIXME Here because the wrong client was getting default set
        $config.client_name = client_id

        # Logically this will only ever be the clients owning account
        $config.find_or_set_default_account
      end
    end
  end
end
