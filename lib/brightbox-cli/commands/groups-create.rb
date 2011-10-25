module Brightbox
  desc 'Create a server group'
  command [:create] do |c|
    c.desc "Name of Server Group"
    c.flag [:n, :name]

    c.desc "Server group description"
    c.flag [:d, :description]

    c.action do |global_options, options, args|
      params = {}

      params[:name] = options[:n] if options[:n]
      params[:description] = options[:d] if options[:d]

      info "Creating a new server group"
      sg = ServerGroup.create(params)
      render_table([sg], global_options)
    end

  end
end
