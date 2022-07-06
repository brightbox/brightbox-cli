module Brightbox
  desc "Lists collaborations scoped to an account"
  command [:collaborators] do |cmd|
    cmd.default_command :list

    cmd.desc "List an accounts collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        collaborations = Collaboration.find_all_or_warn(args)
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Invite a user (via their email address) to collaborate"
    cmd.arg_name "email"
    cmd.command [:invite] do |c|
      c.arg_name "role"
      # This is default because it is currently the only role
      c.default_value "admin"
      c.flag [:role]

      c.action do |global_options, options, args|
        email = args.first
        role = options[:role]
        collaboration = Collaboration.invite(email, role)
        render_table([collaboration], global_options)
      end
    end

    cmd.desc "Resends an invitation email for a pending collaboration"
    cmd.arg_name "collaboration-id"
    cmd.command [:resend] do |c|
      c.action do |global_options, _options, args|
        collaborations = Collaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        collaborations.each { |col| col.resend }
        render_table(collaborations, global_options)
      end
    end

    cmd.desc "Show details of collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        collaborations = Collaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        render_table(collaborations, global_options.merge(:vertical => true))
      end
    end

    cmd.desc "Destroy collaborations"
    cmd.arg_name "[collaboration-id...]"
    cmd.command [:destroy] do |c|
      c.action do |global_options, _options, args|
        collaborations = Collaboration.find_or_call(args) do |id|
          warn "Couldn't find collaboration #{id}"
        end
        collaborations.each { |col| col.destroy }
        render_table(collaborations, global_options)
      end
    end
  end
end
