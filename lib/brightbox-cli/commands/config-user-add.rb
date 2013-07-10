module Brightbox
  desc 'Add new user credentials to config'
  arg_name 'email app-id app-secret [api_url auth_url]'
  command [:user_add] do |c|

    c.desc "user alias, for local reference (defaults to app-id)"
    c.flag [:a, "alias"]

    c.desc "password, if not specified you will be prompted"
    c.flag [:p, "password"]

    c.action do |global_options, options, args|
      info "Using config file #{$config.config_filename}"

      email = args.shift
      app_id = args.shift
      app_secret = args.shift
      api_url = args.shift || "https://api.gb1.brightbox.com"
      auth_url = args.shift || api_url

      calias = options[:a] || app_id
      password = options[:p]

      if app_id.nil?
        raise "You must specify the app-id"
      end

      unless app_id[/^app-.{5}$/]
        raise "You must specify a valid app-id in the format app-xxxxx"
      end

      if app_secret.nil?
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

      client_config['alias'] = calias
      client_config['app_id'] = app_id
      client_config['email'] = email
      client_config['app_secret'] = app_secret
      client_config['api_url'] = api_url
      client_config['auth_url'] = auth_url

      $config.save!(:email => email, :password => password, :client_id => calias)
    end
  end
end
