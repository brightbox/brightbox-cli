module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|
      cmd.desc I18n.t("sql.instances.snapshot.desc")
      cmd.arg_name "[instance-id...]"
      cmd.command [:snapshot] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify SQL instance IDs to snapshot" if args.empty?

          servers = DatabaseServer.find_or_call(args) do |id|
            raise "Couldn't find an SQL instance with ID #{id}"
          end

          servers.each do |server|
            info "Creating snapshot for #{server}"
            server.snapshot
          end
        end
      end
    end
  end
end
