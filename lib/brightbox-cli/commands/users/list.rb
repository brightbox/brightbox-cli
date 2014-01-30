module Brightbox
  desc "Lists the users associated with an account"
  command [:users] do |cmd|

    cmd.default_command :list

    cmd.desc "List users"
    cmd.arg_name "[user-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, options, args|
        users = User.find_all_or_warn(args)
        render_table(users, global_options)
      end
    end
  end
end
