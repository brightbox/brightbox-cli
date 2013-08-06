module Brightbox
  desc "Lists accounts you can access (when using user credentials)"
  command [:"account-access"] do |cmd|

    cmd.default_command :list

    cmd.desc "List your collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, options, args|
        if args.empty?
          collaborations = UserCollaboration.find(:all)
        else
          collaborations = UserCollaboration.find_or_call(args) do |id|
            warn "Couldn't find collaboration #{id}"
          end
        end
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Show details of collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:show] do |c|
      c.action do |global_options, options, args|
        collaborations = UserCollaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        render_table(collaborations, global_options.merge(:vertical => true))
      end
    end

    cmd.desc "Accept collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:accept] do |c|
      c.action do |global_options, options, args|
        collaborations = UserCollaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        collaborations.each {|col| col.accept }
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Reject collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:reject] do |c|
      c.action do |global_options, options, args|
        collaborations = UserCollaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        collaborations.each {|col| col.reject }
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Destroy collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:destroy] do |c|
      c.action do |global_options, options, args|
        collaborations = UserCollaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        collaborations.each {|col| col.destroy }
        render_table(collaborations, global_options)
      end
    end
  end
end
