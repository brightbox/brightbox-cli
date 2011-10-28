module Brightbox
  desc 'Lists the api clients defined in the config'
  command [:client_list] do |c|

    c.action do |global_options, options, args|

      info "Using config file #{CONFIG.config_filename}"

      clients = CONFIG.clients.collect do |cid|
        c = CONFIG[cid]
        calias = c['alias'] || cid
        calias = calias + "*" if CONFIG.client_name == cid and CONFIG.clients.size > 1
        {
          :alias => calias,
          :client_id => c["client_id"],
          :secret => c["secret"],
          :api_url => c["api_url"],
          :auth_url => c["auth_url"] || c["api_url"]
        }
      end

      render_table clients, :fields => [:alias, :client_id, :secret, :api_url, :auth_url]
    end
  end

end
