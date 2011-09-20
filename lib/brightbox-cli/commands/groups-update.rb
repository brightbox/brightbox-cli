module Brightbox
  desc 'Update a server group'
  arg_name 'grp-id'
  command [:update] do |c|

    c.desc "Friendly name of server group"
    c.flag [:n, :name]

    c.desc "Server group description"
    c.flag [:d, :description]

    c.action do |global_options, options, args|
      grp_id = args.shift
      raise "You must specify the server group to update as the first argument" unless grp_id =~ /^grp-/

      sg = ServerGroup.find grp_id
      info "Updating server group #{sg.id}"
      if options[:n]
        params[:name] = options[:n]
      end

      if options[:d]
        params[:description] = options[:d]
      end

      sg = ServerGroup.create(
        params
      )
      render_table([sg], global_options)
    end
  end
end
