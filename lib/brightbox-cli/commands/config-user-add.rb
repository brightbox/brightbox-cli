module Brightbox
  command [:config] do |cmd|

    cmd.desc "Add new user credentials to config"
    cmd.arg_name "email client-id secret [api_url auth_url]"
    cmd.command [:user_add] do |c|

      c.desc "client alias (local reference)"
      c.flag [:a, "alias"]

      c.desc "password, if not specified you will be prompted"
      c.flag [:p, "password"]

      c.action do |global_options, options, args|

        require 'highline'

        info "Using config file #{$config.config_filename}"

        email = args.shift
        client_id = args.shift
        secret = args.shift
        api_url = args.shift || DEFAULT_API_ENDPOINT
        auth_url = args.shift || api_url

        calias = options[:a] || email
        password = options[:p]

        if email.nil?
          raise "You must specify your user's email address"
        end

        if client_id.nil?
          raise "You must specify the client-id"
        end

        unless client_id[/^app-.{5}$/]
          raise "The client-id '#{client_id}' must match the format app-xxxxx"
        end

        if secret.nil?
          raise "You must specify the client secret"
        end

        if !password || password.empty?
          highline = HighLine.new
          password = highline.ask("Enter your password : ") { |q| q.echo = false }
        end

        if password.empty?
          raise "You must specify your Brightbox password."
        end

        options = {
          :username => email,
          :password => password,
          :api_url => api_url,
          :auth_url => auth_url
        }
        $config.add_section(calias, client_id, secret, options)
      end
    end
  end
end
