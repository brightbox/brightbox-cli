require_relative "version"

module Brightbox
  extend GLI::App

  subcommand_option_handling :normal

  # FIXME The official "commands_from" uses require which is slower
  # than require_relative when running under ruby gems. So we'll just
  # implement this ourselves.
  #
  # Need to locate the source of double loading under Aruba
  #
  Dir.glob(File.expand_path("../commands/*.rb", __FILE__)) do |f|
    require_relative File.join('commands', File.basename(f))
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

  pre do |global_options, command, options, args|
    if command.topmost_ancestor.name == :config
      force_default_config = false
    else
      force_default_config = true
    end

    # Configuration options
    config_opts = {
      :force_default_config => force_default_config,
      :client_name => ENV["CLIENT"] || global_options[:client],
      :account => ENV["ACCOUNT"] || global_options[:account]
    }
    $config = BBConfig.new(config_opts)

    # Outputs a snapshot of the tokens known by the client
    $config.debug_tokens

    Excon.defaults[:headers]['User-Agent'] = "brightbox-cli/#{Brightbox::VERSION} Fog/#{Fog::VERSION}"

    Excon.defaults[:headers]['User-Agent'] ||= "brightbox-cli/#{Brightbox::VERSION}"

    if global_options[:k] or ENV["INSECURE"]
      Excon.defaults[:ssl_verify_peer] = false
    end

    unless global_options[:s]
      Hirb.enable
      Hirb::View.resize
    end

    config_alias = $config.alias == $config.client_name ? nil : "(#{$config.alias})"
    info "INFO: client_id: #{$config.client_name} #{config_alias}" if $config.clients.size > 1
    true
  end

  post do |global_options, command, options, args|
    begin
      # Api.conn is another global which holds the authentication tokens so
      # we need to shuffle data between globals at a higher level rather than
      # force one inside the other
      access_token = Api.conn.access_token
      refresh_token = Api.conn.refresh_token

      $config.update_stored_tokens(access_token, refresh_token)
      $config.write_config_file
    rescue BBConfigError
    rescue StandardError => e
      # FIXME Other StandardErrors are available
      warn "Error writing auth token #{$config.access_token_filename}: #{e.class}: #{e}"
    end
  end

  on_error do |e|
    # Try to handle invalid/expired credentials
    if e.is_a?(Excon::Errors::Unauthorized)
      begin
        debug "Refused access token: #{$config.access_token}"
        $config.reauthenticate
      rescue
        false
      ensure
        $config.debug_tokens
      end
    else
      # Handle the rest
      ErrorParser.new(e).pretty_print

      if ENV["DEBUG"]
        debug e
        debug e.class.to_s
        debug e.backtrace.join("\n")
      end
      false # GLI will exit
    end
  end
end
