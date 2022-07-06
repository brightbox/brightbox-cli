module Brightbox
  command [:accounts] do |cmd|
    cmd.default_command :list

    cmd.desc I18n.t("accounts.list.desc")
    cmd.arg_name "[account-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, _args|
        accounts = if Brightbox.config.using_application?
                     # Collaborating Accounts are combined from owned and collaborations
                     CollaboratingAccount.all
                   else
                     Account.find(:all)
                   end

        render_table(accounts, global_options)
      end
    end
  end
end
