module Brightbox
  command [:sql] do |product|
    product.command [:instances] do |cmd|

      cmd.desc I18n.t("sql.instances.update.desc")
      cmd.arg_name "instance-id"
      cmd.command [:update] do |c|

        c.desc I18n.t("options.name.desc")
        c.flag [:n, :name]

        c.desc I18n.t("options.description.desc")
        c.flag [:d, "description"]

        c.desc I18n.t("sql.instances.options.allow_access.desc")
        c.flag [:"allow-access"]

        c.action do |global_options, options, args|
          dbs_id = args.shift
          unless dbs_id =~ /^dbs-/
            raise "You must specify a valid SQL instance ID as the first argument"
          end

          server = DatabaseServer.find dbs_id

          params = NilableHash.new
          params[:name] = options[:n] if options[:n]
          params[:description] = options[:d] if options[:d]

          if options[:"allow-access"]
            access_items = options[:"allow-access"].split(",")
            params[:allow_access] = access_items
          end

          params.nilify_blanks

          info "Updating #{server}"
          server.update params
          server.reload
          render_table([server], global_options)
        end
      end
    end
  end
end
