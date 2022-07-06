module Brightbox
  desc "Lists accounts you can access (when using user credentials)"
  command [:"account-access"] do |cmd|
    cmd.default_command :list

    cmd.desc "List your collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        collaborations = if args.empty?
                           UserCollaboration.find(:all)
                         else
                           UserCollaboration.find_or_call(args) do |id|
                             warn "Couldn't find collaboration #{id}"
                           end
                         end
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Show details of collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        collaborations = UserCollaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        render_table(collaborations, global_options.merge(:vertical => true))
      end
    end
  end
end
