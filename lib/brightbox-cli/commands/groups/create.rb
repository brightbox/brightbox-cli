module Brightbox
  command [:groups] do |cmd|
    cmd.desc I18n.t("groups.create.desc")
    cmd.command [:create] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.action do |global_options, options, _args|
        params = {}

        params[:name] = options[:n] if options[:n]
        params[:description] = options[:d] if options[:d]

        info "Creating a new server group"
        sg = ServerGroup.create(params)
        render_table([sg], global_options)
      end
    end
  end
end
