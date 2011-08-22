module Brightbox
  desc 'Remove api client details from config'
  arg_name 'alias'
  command [:client_remove] do |c|

    c.action do |global_options, options, args|

      info "Using config file #{CONFIG.config_filename}"

      calias = args.shift

      if calias.nil?
        raise "You must specify the api alias you want to remove"
      end

      client_config = CONFIG.clients.detect{|c| CONFIG[c]['alias'] == calias}
      if client_config.nil?
        raise "An api client with the alias #{calias} does not exist in the config"
      end

      info "Removing api client #{calias}"
      CONFIG.delete_section client_config
      CONFIG.save!

    end
  end
end
