module Brightbox
  command [:servers] do |cmd|

    cmd.desc I18n.t("servers.update.desc")
    cmd.arg_name "server-id"
    cmd.command [:update] do |c|

      c.desc I18n.t("options.name.desc")
      c.flag [:n, :name]

      c.desc "Specify user data"
      c.flag [:m, "user-data"]

      c.desc "Specify the user data from a local file"
      c.flag [:f, "user-data-file"]

      c.desc "base64 encode the user data"
      c.default_value true
      c.switch [:e, :base64], :negatable => true

      c.desc "Use compatibility mode"
      c.switch [:"compatibility-mode"], :negatable => true

      c.desc "Server groups to place server in - comma delimited list"
      c.flag [:g, "server-groups"]

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
            require "base64"
            user_data = Base64.encode64(user_data)
          end
          raise "User data too big (>16k)" if user_data.size > 16 * 1024
        end

        params = NilableHash.new
        params[:name] = options[:n] if options[:n]
        params[:user_data] = user_data if user_data

        unless options[:"compatibility-mode"].nil?
          params[:compatibility_mode] = options[:"compatibility-mode"]
        end

        if options[:g]
          # Split server groups into array of identifiers (or empty array)
          server_groups = ServerGroup.find_or_call(options[:g].to_s.split(/,\s*/)) do |id|
            raise "Couldn't find server group with #{id}"
          end

          params[:server_groups] = server_groups.map(&:id)
        end

        params.nilify_blanks

        info "Updating server #{server}#{" with %.2fk of user data" % (user_data.size / 1024.0) if user_data}"
        server.update params
        server.reload
        render_table([server], global_options)
      end
    end
  end
end
