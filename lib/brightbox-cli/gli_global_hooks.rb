require_relative "version"

module Brightbox
  extend GLI::App

  subcommand_option_handling :normal

  # FIXME: The official "commands_from" uses require which is slower
  # than require_relative when running under ruby gems. So we'll just
  # implement this ourselves.
  #
  # Need to locate the source of double loading under Aruba
  #
  subcommand_files = Dir.glob(File.expand_path("../commands/**/*.rb", __FILE__))
  subcommand_files.sort.each do |cmd_file|
    require cmd_file
  end

  sort_help :manually
  version Brightbox::VERSION

  # Global options
  desc "Simple output (tab separated, don't draw fancy tables)"
  switch [:s, :simple], :negatable => false

  desc "Set the api client to use"
  flag [:c, :client]

  desc "Set the account to use"
  flag :account

  desc "Disable peer SSL certificate verification"
  switch [:k, :insecure], :negatable => false

  pre do |global_options, command, _options, _args|
    # Configuration options
    config_opts = {
      :client_name => ENV["CLIENT"] || global_options[:client],
      :account => ENV["ACCOUNT"] || global_options[:account]
    }
    Brightbox.config = BBConfig.new(config_opts)

    # Commands that alter the config files should not error here
    unless [:config].include?(command.topmost_ancestor.name)
      raise AmbiguousClientError, AMBIGUOUS_CLIENT_ERROR if Brightbox.config.client_name.nil?

      if Brightbox.config.has_multiple_clients?
        if Brightbox.config.client_has_alias?
          info "INFO: client_id: #{Brightbox.config.client_name} (#{Brightbox.config.client_alias})"
        else
          info "INFO: client_id: #{Brightbox.config.client_name}"
        end
      end

      # Outputs a snapshot of the tokens known by the client
      Brightbox.config.debug_tokens if Brightbox.config.respond_to?(:debug_tokens)
    end

    Excon.defaults[:headers]['User-Agent'] = "brightbox-cli/#{Brightbox::VERSION} Fog/#{Fog::Core::VERSION}"

    Excon.defaults[:headers]['User-Agent'] ||= "brightbox-cli/#{Brightbox::VERSION}"

    if global_options[:k] || ENV["INSECURE"]
      Excon.defaults[:ssl_verify_peer] = false
    end

    unless global_options[:s]
      Hirb.enable
      Hirb::View.resize
    end

    true
  end

  post do |_global_options, _command, _options, _args|
    begin
      # Api.conn is another global which holds the authentication tokens so
      # we need to shuffle data between globals at a higher level rather than
      # force one inside the other
      access_token = Api.conn.access_token
      refresh_token = Api.conn.refresh_token

      Brightbox.config.update_stored_tokens(access_token, refresh_token)
      Brightbox.config.save
    rescue BBConfigError
    rescue StandardError => e
      # FIXME: Other StandardErrors are available
      warn "Error writing auth token #{Brightbox.config.access_token_filename}: #{e.class}: #{e}"
    end
  end

  on_error do |e|
    # Try to handle invalid/expired credentials
    if e.is_a?(Excon::Errors::Unauthorized)
      begin
        debug "Refused access token: #{Brightbox.config.access_token}"
        Brightbox.config.reauthenticate
        # FIXME: Curious output from info
        info "Your API credentials have been updated, please re-run your command."
        Brightbox.config.debug_tokens if Brightbox.config.respond_to?(:debug_tokens)
        exit(222)
      rescue Brightbox::Api::ApiError
        error "Unable to authenticate with supplied details"
        Brightbox.config.debug_tokens if Brightbox.config.respond_to?(:debug_tokens)
        exit(111)
      rescue Exception => e
        if ENV["DEBUG"]
          debug e
          debug e.class.to_s
          debug e.backtrace.join("\n")
        end
        Brightbox.config.debug_tokens if Brightbox.config.respond_to?(:debug_tokens)
        exit(1)
      end
    else
      # Handle the rest
      ErrorParser.new(e).pretty_print

      if ENV["DEBUG"]
        debug e
        debug e.class.to_s
        debug e.backtrace.join("\n")
      end
      Brightbox.config.debug_tokens if Brightbox.config.respond_to?(:debug_tokens)
      exit(1)
    end
  end
end
