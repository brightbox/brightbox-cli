module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|
      cmd.desc I18n.t("sql.instances.lock.desc")
      cmd.arg_name "[instance-id...]"
      cmd.command [:lock] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify sql instances as arguments" if args.empty?

          instances = DatabaseServer.find_or_call(args) do |instance|
            raise "Couldn't find #{instance}"
          end

          instances.each do |instance|
            info "Locking #{instance}"
            instance.lock!
          end
        end
      end

      cmd.desc I18n.t("sql.instances.unlock.desc")
      cmd.arg_name "[instance-id...]"
      cmd.command [:unlock] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify sql instances as arguments" if args.empty?

          instances = DatabaseServer.find_or_call(args) do |instance|
            raise "Couldn't find #{instance}"
          end

          instances.each do |instance|
            info "Unlocking #{instance}"
            instance.unlock!
          end
        end
      end
    end
  end
end
