module Brightbox
  desc "Authentication token management"
  command [:token] do |cmd|
    cmd.default_command :show

    cmd.desc "Show currently cached OAuth2 Bearer token"
    cmd.command [:show] do |c|
      c.desc "Either 'text', 'token', 'json' or 'curl'"
      c.arg_name "format"
      c.default_value "text"
      c.flag [:format]

      c.action do |_, options, _|
        token = Token.show(Brightbox.config, options)
        $stdout.puts token.format(options[:format] || "text")
      end
    end

  end
end
