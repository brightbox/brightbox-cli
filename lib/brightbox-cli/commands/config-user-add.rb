module Brightbox
  command [:config] do |cmd|

    cmd.desc "Add new user credentials to config"
    cmd.arg_name "email client-id secret [api_url auth_url]"
    cmd.command [:user_add] do |c|

      c.desc "user alias, for local reference (defaults to client-id)"
      c.flag [:a, "alias"]

      c.desc "password, if not specified you will be prompted"
      c.flag [:p, "password"]

      c.action do |global_options, options, args|

        require 'highline'

        info "Using config file #{$config.config_filename}"

        email = args.shift
        client_id = args.shift
        secret = args.shift
        api_url = args.shift || "https://api.gb1.brightbox.com"
        auth_url = args.shift || api_url

        calias = options[:a] || client_id
        password = options[:p]

        if client_id.nil?
          raise "You must specify the client-id"
        end

        unless client_id[/^app-.{5}$/]
          raise "You must specify a valid client-id in the format app-xxxxx"
        end

        if secret.nil?
          raise "You must specify the api secret"
        end

        if !password || password.empty?
          highline = HighLine.new()
          password = highline.ask("Enter your password : ") { |q| q.echo = false }
        end

        if password.empty?
          raise "You must specify your Brightbox password."
        end

        client_config = $config[calias]
        unless client_config.empty?
          old_calias = calias

          deduplicator = Brightbox::Config::SectionNameDeduplicator.new(calias, $config.clients)
          calias = deduplicator.next
          # Need to open the new config again
          client_config = $config[calias]

          info "A client config named #{old_calias} already exists using #{calias} instead"
        else
          info "Creating new client config #{calias}"
        end

        client_config["alias"] = calias
        client_config["client_id"] = client_id
        client_config["username"] = email
        client_config["secret"] = secret
        client_config["api_url"] = api_url
        client_config["auth_url"] = auth_url

        $config.write_config_file

        # Renew tokens via config...
        begin
          $config.renew_tokens(:client_name => calias, :password => password)
        rescue => e
          error "Something went wrong trying to refresh new tokens #{e.message}"
        end

        # Try to determine a default account
        if $config.find_or_set_default_account
          info "The default account of #{$config.default_account} has been selected"
        end
      end
    end
  end
end
