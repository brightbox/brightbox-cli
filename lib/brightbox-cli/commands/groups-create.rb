module Brightbox
  desc 'Create a server group'
  arg_name 'name'
  command [:create] do |c|
    c.desc "Server group description"
    c.flag [:d, :description]

    c.action do |global_options, options, args|
      name = args.shift
      raise "You must specify a name for the server group" unless name && name != ""

      info "Creating a new server group"
      sg = ServerGroup.create(
        :name => name,
        :description => options[:d]
      )
      render_table([sg], global_options)
    end

  end
end
