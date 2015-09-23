module Brightbox
  command [:login] do |cmd|
    cmd.desc I18n.t("login.desc")
    cmd.arg_name "email"

    cmd.desc "password, if not specified you will be prompted"
    cmd.flag [:p, "password"]

    cmd.desc "default account"
    cmd.flag [:a, :account]

    cmd.flag [:"application-id"]
    cmd.flag [:"application-secret"]

    cmd.flag [:"api-url"]
    cmd.flag [:"auth-url"]

    cmd.action do |_global_options, options, args|
      email = args.shift
      password = options[:p]

      api_url = options[:"api-url"] || DEFAULT_API_ENDPOINT
      auth_url = options[:"auth-url"] || api_url

      # These are public credentials and are not used for authentication
      # They only work with a valid username and passowrd
      # Don't use them for anything else though they can be reset at any time.
      client_id = options[:"application-id"] || "app-12345"
      secret = options[:"application-secret"] || "mocbuipbiaa6k6c"

      raise "You must specify your user's email address" if email.nil?

      if !password || password.empty?
        require "highline"
        highline = HighLine.new
        password = highline.ask("Enter your password : ") { |q| q.echo = false }
      end

      raise "You must specify your Brightbox password." if password.empty?

      section_options = {
        :username => email,
        :password => password,
        :api_url => api_url,
        :auth_url => auth_url
      }
      section_options[:default_account] = options[:account] if options.key?(:account)
      $config.add_section(email, client_id, secret, section_options)
    end
  end
end
