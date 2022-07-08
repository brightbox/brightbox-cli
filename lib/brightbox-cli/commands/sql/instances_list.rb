module Brightbox
  command [:sql] do |product|
    product.default_command :instances
    product.command [:instances] do |cmd|
      cmd.default_command :list

      cmd.desc I18n.t("sql.instances.list.desc")

      cmd.arg_name "[instance-id...]"
      cmd.command [:list] do |c|
        c.action do |global_options, _options, args|
          servers = if args.empty?
                      DatabaseServer.find(:all)
                    else
                      DatabaseServer.find_or_call(args) do |id|
                        warn "Couldn't find server #{id}"
                      end
                    end

          render_table(servers, global_options)
        end
      end
    end
  end
end
