module Brightbox
  command [:users] do |cmd|

    cmd.desc I18n.t("users.show.desc")
    cmd.arg_name "user-id..."
    cmd.command [:show] do |c|

      c.action do |global_options, _options, args|
        users = User.find_all_or_warn(args)

        table_opts = global_options.merge(
          :vertical => true,
          :fields => [:id, :name, :email_address, :accounts, :ssh_key]
        )

        render_table(users, table_opts)
      end
    end
  end
end
