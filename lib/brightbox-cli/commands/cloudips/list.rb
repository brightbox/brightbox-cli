module Brightbox
  command [:cloudips] do |cmd|

    cmd.default_command :list

    cmd.desc I18n.t("cloudips.list.desc")
    cmd.arg_name "[cloudip-id...]"
    cmd.command [:list] do |c|

      c.action do |global_options, _options, args|
        ips = CloudIP.find_all_or_warn(args)
        render_table(ips.sort, global_options)
      end
    end
  end
end
