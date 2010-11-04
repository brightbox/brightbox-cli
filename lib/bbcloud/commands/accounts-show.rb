desc 'Show detailed account info'
arg_name 'account-id...'
command [:show] do |c|

  c.action do |global_options,options,args|

    accounts = Account.find(args).compact

    table_opts = global_options.merge({
      :vertical => true,
      :fields => [:id, :name, :cloud_ip_limit, :ram_limit, :ram_used, 
                  :ram_free, :library_ftp_host, :library_ftp_user ]
    })

    render_table(accounts, table_opts)

  end
end
