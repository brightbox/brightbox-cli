module Brightbox
  command [:accounts] do |cmd|

    cmd.desc "Refuses or removes an account collaboration"
    cmd.arg_name "account_id"
    cmd.command [:remove] do |c|
      c.action do |global_options, options, args|
        account_id = args.first

        # Find the collaboration for that account
        collaboration = UserCollaboration.get_for_account(account_id)
        if collaboration
          collaboration.remove
        else
          raise "Couldn't find an invite for account #{account_id}"
        end

        render_table([collaboration], global_options)
      end
    end
  end
end
