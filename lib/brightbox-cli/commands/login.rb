module Brightbox
  desc I18n.t("login.desc")
  arg :email
  command [:login] do |cmd|
    cmd.desc "password, if not specified you will be prompted"
    cmd.flag [:p, "password"], arg_name: "password"

    cmd.desc "Set a default account"
    cmd.flag [:"default-account"], arg_name: "acc-12345"

    cmd.flag [:"application-id"]
    cmd.flag [:"application-secret"]

    cmd.flag [:"api-url"]
    cmd.flag [:"auth-url"]

    cmd.action do |_global_options, options, args|
      config_name = args.shift
      email = config_name

      raise "You must specify your email address" if email.nil?

      password = Brightbox.config.discover_password(password: options[:p])
      raise "You must specify your Brightbox password." if password.empty?

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

      begin
        Brightbox.config.add_login(email, password, section_options)
      rescue Fog::Brightbox::OAuth2::TwoFactorMissingError
        section_options = {
          :client_name => config_name,
          :alias => config_name,
          :username => email,
          :password => password,
          :one_time_password => discover_two_factor_pin
        }
        Brightbox.config.add_login(email, password, section_options)
      end
    end
  end
end
