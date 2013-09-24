module Brightbox
  command [:config] do |cmd|

    cmd.default_command :client_list

    cmd.desc "Lists the api clients defined in the config"
    cmd.command [:client_list] do |c|

      c.action do |global_options, options, args|

        info "Using config file #{$config.config_filename}"

        clients = $config.clients.collect do |cid|
          c = $config[cid]
          calias = c["alias"] || cid

          # Append a star for the configured default client
          if $config.default_client == cid and $config.clients.size > 1
            calias = "*#{calias}"
          end

          {
            :alias => calias,
            :client_id => c["client_id"],
            :secret => c["secret"],
            :api_url => c["api_url"],
            :auth_url => c["auth_url"] || c["api_url"]
          }
        end

        render_table clients, global_options.merge(:fields => [:alias, :client_id, :secret, :api_url, :auth_url])
      end
    end
  end
end
