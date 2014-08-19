module Brightbox
  command [:sql] do |product|
    product.command [:snapshots] do |cmd|
      cmd.desc I18n.t("sql.snapshots.lock.desc")
      cmd.arg_name "[snapshot-id...]"
      cmd.command [:lock] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify sql snapshots as arguments" if args.empty?

          snapshots = DatabaseSnapshot.find_or_call(args) do |snapshot|
            raise "Couldn't find #{snapshot}"
          end

          snapshots.each do |snapshot|
            info "Locking #{snapshot}"
            snapshot.lock!
          end
        end
      end

      cmd.desc I18n.t("sql.snapshots.unlock.desc")
      cmd.arg_name "[snapshot-id...]"
      cmd.command [:unlock] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify sql snapshots as arguments" if args.empty?

          snapshots = DatabaseSnapshot.find_or_call(args) do |snapshot|
            raise "Couldn't find #{snapshot}"
          end

          snapshots.each do |snapshot|
            info "Unlocking #{snapshot}"
            snapshot.unlock!
          end
        end
      end
    end
  end
end
