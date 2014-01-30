module Brightbox
  command [:groups] do |cmd|

    cmd.default_command :list

    cmd.desc "List server groups"
    cmd.command [:list] do |c|
      c.action do |global_options, options, args|
        server_groups = ServerGroup.find_all_or_warn(args)
        render_table(server_groups, global_options)
      end
    end
  end
end
