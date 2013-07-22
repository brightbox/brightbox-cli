require_relative "version"

module Brightbox
  extend GLI::App

  subcommand_option_handling :normal

  # FIXME The official "commands_from" will try and reload them without
  # correctly having the subcommand_option_handling set to :normal
  # This generates errors that flags are in use BY THE SAME command!
  #
  # Need to locate the source of double loading under Aruba
  #
  begin
    commands_from File.expand_path("../commands", __FILE__)
  rescue ArgumentError
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

    $config = BBConfig.new(:force_default_config => force_default_config)
    $config.client_name = ENV["CLIENT"] if ENV["CLIENT"]
    $config.client_name = global_options[:c] if global_options[:c]
    $config.account = ENV["ACCOUNT"] if ENV["ACCOUNT"]
    $config.account = global_options[:account] if global_options[:account]

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
    $config.finish
  end

  on_error do |e|
    ErrorParser.new(e).pretty_print()
    debug e
    debug e.class.to_s
    debug e.backtrace.join("\n")
    exit 1
  end
end
