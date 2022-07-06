module Brightbox
  command [:accounts] do |cmd|
    cmd.desc I18n.t("accounts.reset_ftp_password.desc")
    cmd.arg_name "account-id..."
    cmd.command [:reset_ftp_password] do |c|
      c.action do |global_options, _options, args|
        if args.empty?
          raise "You must specify the accounts to reset ftp passwords for"
        end

        accounts = Account.find_or_call(args) do |id|
          raise "Couldn't find account #{id}"
        end

        rows = []

        accounts.each do |s|
          info "Resetting ftp password for #{s}"
          new_password = s.reset_ftp_password
          o = s.to_row
          o[:library_ftp_password] = new_password
          rows << o
        end

        table_opts = global_options.merge(
          :vertical => true,
          :fields => %i[
            id
            name
            library_ftp_host
            library_ftp_user
            library_ftp_password
          ]
        )

        render_table(rows, table_opts)
      end
    end
  end
end
