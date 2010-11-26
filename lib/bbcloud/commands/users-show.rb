desc 'Show detailed user info'
arg_name 'user-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    if args.empty?
      raise "You must specify the users you want to show"
    end

    users = User.find_or_call(args) do |id|
      warn "Couldn't find user #{id}"
    end

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :name, :email_address, :accounts, :ssh_key ]
    })

    render_table(users, table_opts)

  end
end
