module Brightbox
  desc 'Show detailed account info'
  arg_name 'account-id...'
  command [:show] do |c|

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the accounts to show"
      end

      accounts = Account.find_or_call(args) do |id|
        warn "Couldn't find account #{id}"
      end

      table_opts = global_options.merge({
        :vertical => true,
        :fields => [:id, :name, :cloud_ip_limit, :ram_limit, :ram_used,
                    :ram_free, :library_ftp_host, :library_ftp_user ]
      })

      render_table(accounts, table_opts)

    end
  end
end


