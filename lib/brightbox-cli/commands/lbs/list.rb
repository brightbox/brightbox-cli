module Brightbox
  command [:lbs] do |cmd|

    cmd.default_command :list

    cmd.desc I18n.t("lbs.list.desc")
    cmd.arg_name "[lb-id...]"
    cmd.command [:list] do |c|
      c.action do |global_options, _options, args|
        lbs = LoadBalancer.find_all_or_warn(args)
        render_table(lbs, global_options)
      end
    end
  end
end
