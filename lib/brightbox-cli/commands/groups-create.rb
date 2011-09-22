module Brightbox
  desc 'Create a server group'
  arg_name 'name'
  command [:create] do |c|
    c.desc "Server group description"
    c.flag [:d, :description]

    c.action do |global_options, options, args|
      name = args.shift
      raise "You must specify a name for the server group" unless name && name != ""

      params = {}

      params[:name] = name
      params[:description] = options[:d] if options[:d]

      info "Creating a new server group"
      sg = ServerGroup.create(params)
      render_table([sg], global_options)
    end

  end
end
