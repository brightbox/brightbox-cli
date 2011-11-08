module Brightbox
  desc 'Add new api client details to config'
  arg_name 'client-id secret [api_url, auth_url]'
  command [:client_add] do |c|

    c.desc "api client alias, for local reference (defaults to client-id)"
    c.flag [:a, "alias"]

    c.desc "auth url"
    c.flag [:t, "auth-url"]

    c.action do |global_options, options, args|

      info "Using config file #{CONFIG.config_filename}"

      client_id = args.shift
      secret = args.shift
      api_url = args.shift || "https://api.gb1.brightbox.com"
      auth_url = args.shift || api_url
      calias = options[:a] || client_id

      if client_id.nil?
        raise "You must specify the api client-id"
      end

      unless client_id[/^cli-.{5}$/]
        raise "You must specify a valid api client-id in the format cli-xxxxx"
      end

      if secret.nil?
        raise "You must specify the api secret"
      end

      client_config = CONFIG[calias]
      unless client_config.empty?
        raise "An api client with the id or alias #{calias} already exists"
      end

      info "Creating new api client config #{calias}"

      client_config['alias'] = calias
      client_config['client_id'] = client_id
      client_config['secret'] = secret
      client_config['api_url'] = api_url
      client_config['auth_url'] = auth_url

      CONFIG.save!

    end
  end
end
