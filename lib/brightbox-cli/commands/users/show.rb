module Brightbox
  command [:users] do |cmd|
    cmd.desc I18n.t("users.show.desc")
    cmd.arg_name "user-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        raise "You must specify user IDs to show" if args.empty?

        users = User.find_or_call(args) do |id|
          raise "Couldn't find a user with ID #{id}"
        end

        table_opts = global_options.merge(
          :vertical => true,
          :fields => %i[id name email_address accounts ssh_key]
        )

        render_table(users, table_opts)
      end
    end
  end
end
