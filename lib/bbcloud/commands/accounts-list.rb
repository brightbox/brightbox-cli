desc 'List accounts'
arg_name '[account-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|

    accounts = Account.find args

    render_table(accounts, global_options)
  end
end
