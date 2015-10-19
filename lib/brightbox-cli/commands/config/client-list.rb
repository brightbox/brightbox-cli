module Brightbox
  command [:config] do |cmd|

    cmd.default_command :client_list

    cmd.desc I18n.t("config.client_list.desc")
    cmd.command [:client_list] do |c|

      c.action do |global_options, _options, _args|

        info "Using config file #{Brightbox.config.config_filename}"

        clients = Brightbox.config.section_names.map do |cid|
          c = Brightbox.config[cid]
          calias = c["alias"] || cid

          # Append a star for the configured default client
          if Brightbox.config.default_client == cid && Brightbox.config.has_multiple_clients?
            calias = "*#{calias}"
          end

          {
            :alias => calias,
            :client_id => c["client_id"] || Brightbox::EMBEDDED_APP_ID,
            :secret => c["secret"] || Brightbox::EMBEDDED_APP_SECRET,
            :api_url => c["api_url"],
            :auth_url => c["auth_url"] || c["api_url"]
          }
        end

        render_table clients, global_options.merge(:fields => [:alias, :client_id, :secret, :api_url, :auth_url])
      end
    end
  end
end
