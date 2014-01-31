module Brightbox
  command [:groups] do |cmd|

    cmd.desc "Destroy server groups"
    cmd.arg_name "grp-id..."
    # TODO: add option to remove all servers from group before destroying
    cmd.command [:destroy] do |c|

      c.action do |global_options, options, args|
        raise "You must specify the server groups to destroy" if args.empty?

        sgs = ServerGroup.find_or_call(args) do |id|
          raise "Couldn't find server group #{id}"
        end

        sgs.each do |sg|
          info "Destroying server group #{sg}"
          sg.destroy
        end
      end
    end
  end
end
