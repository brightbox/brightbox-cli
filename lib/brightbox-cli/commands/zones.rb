module Brightbox
  desc "Lists the zones available to an account or see more details"
  command [:zones] do |cmd|
    cmd.default_command :list

    cmd.desc "List zones"
    cmd.arg_name "[zone-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        zones = if args.empty?
                  Zone.find(:all)
                else
                  Zone.find_or_call(args) do |id|
                    warn "Couldn't find zone #{id}"
                  end
                end

        render_table(zones, global_options)
      end
    end
  end
end
