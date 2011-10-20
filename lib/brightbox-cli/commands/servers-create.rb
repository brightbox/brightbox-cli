module Brightbox
  desc 'Create servers'
  arg_name 'image_id'
  command [:create] do |c|

    c.desc "Number of servers to create"
    c.default_value 1
    c.flag [:i, "server-count"]

    c.desc "Zone to create the servers in"
    c.flag [:z, "zone"]

    c.desc "Type of server to create"
    c.default_value "nano"
    c.flag [:t, :type]

    c.desc "Friendly name of server"
    c.flag [:n, :name]

    c.desc "Specify user data"
    c.flag [:m, "user-data"]

    c.desc "Specify the user data from a local file"
    c.flag [:f, "user-data-file"]

    c.desc "Don't base64 encode the user data"
    c.switch [:e, :no_base64]

    c.desc "Server groups to place server in - comma delimited list"
    c.flag [:g, "server-groups"]

    c.action do |global_options, options, args|

      if args.empty?
        raise "You must specify the image_id as the first argument"
      end

      if options[:i].to_s !~ /^[0-9]+$/
        raise "server-count must be a number"
      end

      options[:i] = options[:i].to_i

      image_id = args.shift
      image = Image.find image_id

      type_id = options[:t]
      if type_id =~ /^typ\-/
        type = Type.find type_id
      else
        type = Type.find_by_handle type_id
      end

      if options[:z]
        zone = options[:z]
        if zone =~ /^typ\-/
          zone = Zone.find zone
        else
          zone = Zone.find_by_handle zone
        end
      end

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

      # Split server groups into array of identifiers (or empty array)
      server_groups = ServerGroup.find_or_call(options[:g].to_s.split(/,\s*/)) do |id|
        raise "Couldn't find server #{id}"
      end

      msg = "Creating #{options[:i] > 1 ? options[:i] : 'a'} #{type.handle} (#{type.id})"
      msg << " server#{options[:i] > 1 ? 's' : ''} with image #{image.name.strip} (#{image.id})"
      msg << " in zone #{zone.handle} (#{zone})" if zone
      msg << " in groups #{server_groups.map(&:id).join(", ")}" unless server_groups.empty?
      msg << " with %.2fk of user data" % (user_data.size / 1024.0) if user_data
      info msg

      params = {
        :image_id      => image.id,
        :flavor_id     => type.id,
        :zone_id       => zone.to_s,
        :name          => options[:n],
        :user_data     => user_data,
        :server_groups => server_groups.map(&:id)
      }

      servers = Server.create_servers options[:i], params
      render_table(servers, global_options)
    end
  end
end
