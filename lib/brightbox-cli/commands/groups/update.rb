module Brightbox
  command [:groups] do |cmd|

    cmd.desc "Update a server group"
    cmd.arg_name "grp-id"
    cmd.command [:update] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag [:n, :name]

      c.desc I18n.t("options.description.desc")
      c.flag [:d, :description]

      c.action do |global_options, options, args|
        grp_id = args.shift
        raise "You must specify the server group to update as the first argument" unless grp_id =~ /^grp-/

        params = NilableHash.new

        if options[:n]
          params[:name] = options[:n]
        end

        if options[:d]
          params[:description] = options[:d]
        end

        params.nilify_blanks

        sg = ServerGroup.find grp_id
        info "Updating server group #{sg}"
        sg = sg.update(params)
        render_table([sg], global_options)
      end
    end
  end
end
