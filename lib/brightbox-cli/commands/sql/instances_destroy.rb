module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|
      cmd.desc I18n.t("sql.instances.destroy.desc")
      cmd.arg_name "[instance-id...]"
      cmd.command [:destroy] do |c|
        c.action do |_global_options, _options, args|
          raise "You must specify instance IDs to destroy" if args.empty?

          servers = DatabaseServer.find_or_call(args) do |id|
            raise "Couldn't find an SQL instance with ID #{id}"
          end

          servers.each do |server|
            info "Destroying server instance #{server}"
            begin
              server.destroy
            rescue Brightbox::Api::Conflict
              error "Could not destroy #{server}"
            end
          end
        end
      end
    end
  end
end
