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
          raise "A user application with the id or alias #{calias} already exists"
        end

        info "Creating new user application config #{calias}"

        client_config["alias"] = calias
        client_config["client_id"] = client_id
        client_config["email"] = email
        client_config["secret"] = secret
        client_config["api_url"] = api_url
        client_config["auth_url"] = auth_url

        refresh_token_options = {:email => email, :password => password, :client_id => calias}
        fetch_refresh_token(refresh_token_options)
      end
    end
  end
end
