module Brightbox
  command [:users] do |cmd|
    cmd.desc I18n.t("users.update.desc")
    cmd.arg_name "user-id..."
    cmd.command [:update] do |c|
      c.desc "Path to public ssh key file"
      c.long_desc "This is the path to the public ssh key that you'd like to use
      for new servers. You can specify '-' to read from stdin"
      c.flag [:f, "ssh-key"]

      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.action do |global_options, options, args|
        raise "You must specify the user id as the first argument" if args.empty?

        user = User.find args.first

        if options[:f] == "-"
          user.ssh_key = $stdin.read
        elsif options[:f]
          File.open(File.expand_path(options[:f])) { |f| user.ssh_key = f.read }
        end

        user.name = options[:n] if options[:n]

        user.save

        table_opts = global_options.merge(
          :vertical => true,
          :fields => %i[id name email_address ssh_key]
        )

        render_table([user], table_opts)
      end
    end
  end
end
