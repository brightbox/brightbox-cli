desc 'Show detailed user info'
arg_name 'user-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    users = User.find(args)

    rows = []

    users.each do |s|
      s.reload # to get ssh_key
      o = s.to_row
      o[:ssh_key] = s.ssh_key.to_s.strip
      o[:accounts] = s.accounts.collect { |a| a.id }.join(", ")
      rows << o
    end

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :name, :email_address, :accounts, :ssh_key ]
    })

    render_table(rows, table_opts)

  end
end
