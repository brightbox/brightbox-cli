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
          raise "You must specify the client-id"
        end

        unless client_id[/^cli-.{5}$/]
          raise "The client-id '#{client_id}' must match the format cli-xxxxx"
        end

        if secret.nil?
          raise "You must specify the client secret"
        end

        options = {
          :api_url => api_url,
          :auth_url => auth_url
        }
        $config.add_section(calias, client_id, secret, options)
      end
    end
  end
end
