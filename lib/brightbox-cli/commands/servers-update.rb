module Brightbox
  desc 'Update a server'
  arg_name 'srv-id'
  command [:update] do |c|
    c.desc "Friendly name of server"
    c.flag [:n, :name]

    c.desc "Specify user data"
    c.flag [:m, "user-data"]

    c.desc "Specify the user data from a local file"
    c.flag [:f, "user-data-file"]

    c.desc "Don't base64 encode the user data"
    c.switch [:e, :no_base64]

    c.action do |global_options, options, args|
      srv_id = args.shift
      raise "You must specify a valid server id as the first argument" unless srv_id =~ /^srv-/

      server = Server.find srv_id

      user_data = options[:m]
      user_data_file = options[:f]

      if user_data_file
        raise "Cannot specify user data on command line and in file at same time" if user_data
        # Wot we use to read the data, be it from stdin or a file on disk
        file_handler = lambda do |fh|
          raise "User data file too big (>16k)" if fh.stat.size > 16 * 1024
          user_data = fh.read
        end
        # Figure out how to invoke file_handler, and then invoke it
        if user_data_file == "-"
          file_handler[$stdin]
        else
          File.open user_data_file, "r", &file_handler
        end
      end

      if user_data
        unless options[:e]
          require 'base64'
          user_data = Base64.encode64(user_data)
        end
        raise "User data too big (>16k)" if user_data.size > 16 * 1024
      end

      params = NilableHash.new
      params[:name] = options[:n] if options[:n]
      params[:user_data] = user_data if user_data
      params.nilify_blanks

      info "Updating server #{server}#{" with %.2fk of user data" % (user_data.size / 1024.0) if user_data}"
      server.update params
      server.reload
      render_table([server], global_options)
    end
  end
end
