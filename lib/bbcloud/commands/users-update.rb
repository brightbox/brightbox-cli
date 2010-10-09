desc 'Update user details'
arg_name 'user-id...'
command [:update] do |c|
  c.desc "Path to public ssh key file"
  c.flag [:f, "ssh-key"]

  c.desc "Name"
  c.flag [:n, "name"]

  c.action do |global_options, options, args|

    raise "You must specify the user id as the first argument" if args.empty?

    user = User.find args.first

    raise "Could not find user #{args.first}" if user.nil?
      
    if options[:f] == '-'
      user.ssh_key = STDIN.read
    elsif options[:f]
      File.open(options[:f]) { |f| user.ssh_key = f.read }
    end

    if options[:n]
      user.name = options[:n]
    end

    user.save

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :name, :email_address, :ssh_key ]
    })

    render_table([user], table_opts)

  end
end
