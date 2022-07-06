module Brightbox
  command [:sql] do |product|
    product.desc I18n.t("sql.snapshots.desc")
    product.command [:snapshots] do |cmd|
      cmd.desc I18n.t("sql.snapshots.destroy.desc")
      cmd.arg_name "[snapshot-id...]"

      cmd.command [:destroy] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify snapshots to destroy" if args.empty?

          snapshots = DatabaseSnapshot.find_or_call(args) do |id|
            raise "Couldn't find snapshot #{id}"
          end

          snapshots.each do |snapshot|
            info "Destroying snapshot #{snapshot}"
            begin
              snapshot.destroy
            rescue Brightbox::Api::Conflict
              error "Could not destroy #{snapshot}"
            end
          end
        end
      end
    end
  end
end
