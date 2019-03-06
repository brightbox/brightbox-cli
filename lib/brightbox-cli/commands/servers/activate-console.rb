require "uri"

module Brightbox
  desc I18n.t("servers.desc")
  command [:servers] do |cmd|

    cmd.desc I18n.t("servers.activate_console.desc")
    cmd.arg_name "server-id..."
    cmd.command [:activate_console] do |c|

      c.action do |global_options, _options, args|

        raise "You must specify servers to activate the console for" if args.empty?

        servers = Server.find_or_call(args) do |id|
          raise "Couldn't find server #{id}"
        end

        consoles = []

        servers.each do |s|
          info "Activating console for server #{s}"
          r = s.activate_console

          uri = URI(r["console_url"])
          uri.query = "password=#{r["console_token"]}"

          expires = Time.parse(r["console_token_expires"])
          consoles << { :url => uri.to_s, :token => r["console_token"], :expires => expires.localtime.to_s }
        end

        render_table(consoles, global_options.merge(:fields => [:url, :token, :expires], :resize => false))
      end
    end
  end
end
