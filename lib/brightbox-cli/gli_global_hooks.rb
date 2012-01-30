module Brightbox
  extend GLI
  # Global options
  desc "Simple output (tab separated, don't draw fancy tables)"
  switch [:s, :simple]

  desc "Set the api client to use (named in #{CONFIG.config_filename})"
  flag [:c, :client]

  desc "Disable peer SSL certificate verification"
  switch [:k, :insecure]

  desc "Display Help"
  switch [:h, :help]

  # Load the command libraries for the current group
  cmd_group_name = File.basename($0).gsub(/brightbox\-/, '')
  cmd_group_files = File.join(File.dirname(__FILE__), "commands/#{cmd_group_name}*.rb")
  Dir.glob(cmd_group_files).each do |f|
    load f
  end

  pre do |global_options, command, options, args|
    CONFIG.client_name = ENV["CLIENT"] if ENV["CLIENT"]
    CONFIG.client_name = global_options[:c] if global_options[:c]

    if global_options[:k] or ENV["INSECURE"]
      Excon.ssl_verify_peer = false
      # FIXME: Overriding this here is not good.  Excon calls
      # post_connection_check so it should have an option not to.
      class OpenSSL::SSL::SSLSocket
        def post_connection_check(hostname)
          true
        end
      end
    end

    unless global_options[:s]
      Hirb.enable
      Hirb::View.resize
    end

    command = commands[:help] if global_options[:h]
    config_alias = CONFIG.alias == CONFIG.client_name ? nil : "(#{CONFIG.alias})"
    info "INFO: client_id: #{CONFIG.client_name} #{config_alias}" if CONFIG.clients.size > 1
    true
  end

  on_error do |e|
    ErrorParser.new(e).pretty_print()
    debug e
    debug e.class.to_s
    debug e.backtrace.join("\n")
    exit 1
  end

  desc 'Display version information'
  command [:version] do |c|
    c.action do |global_options, options, args|
      info "Brightbox CLI version: #{Brightbox::VERSION}"
    end
  end
end
