module Brightbox
  command [:cloudips] do |cmd|

    cmd.default_command :list

    cmd.desc "List Cloud IPs"
    cmd.arg_name "[cloudip-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, options, args|
        ips = CloudIP.find_all_or_warn(args)
        render_table(ips.sort, global_options)
      end
    end
  end
end
