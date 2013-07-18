module Brightbox
  command [:accounts] do |cmd|

    cmd.default_command :list

    cmd.desc "List accounts"
    cmd.arg_name "[account-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, options, args|

        if args.empty?
          accounts = Account.find(:all)
        else
          accounts = Account.find_or_call(args) do |id|
            warn "Couldn't find account #{id}"
          end
        end

        render_table(accounts, global_options)
      end
    end
  end
end
