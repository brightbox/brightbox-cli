desc 'List users'
arg_name '[user-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

    users = User.find args

    render_table(users, global_options)
  end
end
