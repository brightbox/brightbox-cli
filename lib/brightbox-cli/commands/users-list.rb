module Brightbox
  desc 'List users'
  arg_name '[user-id...]'
  command [:list] do |c|
    c.action do |global_options, options, args|

      if args.empty?
        users = User.find(:all)
      else
        users = User.find_or_call(args) do |id|
          warn "Couldn't find user #{id}"
        end
      end

      render_table(users, global_options)
    end
  end
end
