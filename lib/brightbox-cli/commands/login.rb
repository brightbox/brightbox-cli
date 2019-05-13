module Brightbox
  command [:login] do |cmd|
    cmd.desc I18n.t("login.desc")
    cmd.arg_name "email"

    cmd.desc "password, if not specified you will be prompted"
    cmd.flag [:p, "password"]

    cmd.desc "default account"
    cmd.flag [:"default-account"]

    cmd.flag [:"application-id"]
    cmd.flag [:"application-secret"]

    cmd.flag [:"api-url"]
    cmd.flag [:"auth-url"]

    cmd.action do |_global_options, options, args|
      config_name = args.shift
      email = config_name

      raise "You must specify your email address" if email.nil?

      password = options[:p]
      password ||= Brightbox.config.gpg_password
      password ||= Brightbox.config.password_helper_password

      if !password || password.empty?
        require "highline"
        highline = HighLine.new
        password = highline.ask("Enter your password : ") { |q| q.echo = false }
      end
      raise "You must specify your Brightbox password." if password.empty?

      if (two_factor_pin = Brightbox.config.two_factor_pin)
        password = password + "+" + two_factor_pin
      end

      section_options = {
        :client_name => config_name,
        :alias => config_name,
        :username => email,
        :password => password
      }

      section_options[:api_url] = options[:"api-url"] if options[:"api-url"]
      section_options[:auth_url] = options[:"auth-url"] if options[:"auth-url"]

      section_options[:default_account] = options[:"default-account"] if options[:"default-account"]

      section_options[:client_id] = options[:"application-id"] if options[:"application-id"]
      section_options[:secret] = options[:"application-secret"] if options[:"application-secret"]

      Brightbox.config.add_login(email, password, section_options)
    end
  end
end
