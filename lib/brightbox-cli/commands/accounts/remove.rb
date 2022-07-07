module Brightbox
  command [:accounts] do |cmd|
    cmd.desc I18n.t("accounts.remove.desc")
    cmd.arg_name "account_id"
    cmd.command [:remove] do |c|
      c.action do |global_options, _options, args|
        account_id = args.first

        # Find the collaboration for that account
        collaboration = UserCollaboration.get_for_account(account_id)
        raise "Couldn't find an invite for account #{account_id}" unless collaboration

        collaboration.remove
        render_table([collaboration], global_options)
      end
    end
  end
end
