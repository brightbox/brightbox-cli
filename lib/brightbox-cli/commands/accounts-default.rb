module Brightbox
  desc "Manages the accounts"
  command [:accounts] do |cmd|

    cmd.desc "Set a default account"
    cmd.arg_name "account-id"
    cmd.command [:default] do |c|

      c.action do |global_options, options, args|

        if args.empty?
          raise "You must specify the account-id to set as default."
        end
        account_id = args.shift
        account = Account.find(account_id)

        unless account
          raise "Invalid account-id"
        end

        $config.save_default_account(account_id)
      end
    end
  end
end
