module Brightbox
  desc 'Set a default account'
  arg_name 'account-id'
  command [:default] do |c|

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the account-id to set as default."
      end
      account_id = args.shift
      account = Account.find(account_id)

      unless account
        raise "Invalid account-id"
      end

      CONFIG.save_default_account(account_id)
    end
  end
end


