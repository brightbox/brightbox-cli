module Brightbox
  command [:images] do |cmd|
    cmd.desc I18n.t("images.register.desc")
    cmd.command [:register] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.desc "Image Username"
      c.flag [:u, "username"]

      c.desc "Architecture of the image (i686 or x86_64)"
      c.flag [:a, "arch"]

      c.desc "Source filename of the image you uploaded to the image library"
      c.flag [:s, "source"]

      c.desc "Source server ID to create image from"
      c.flag ["server"]

      c.desc "Source URL of the image to download via HTTP"
      c.flag ["url"]

      c.desc "Source volume ID to create image from"
      c.flag ["volume"]

      c.desc "Set image mode to be either 'virtio' or 'compatibility'"
      c.default_value "virtio"
      c.flag [:m, "mode"]

      c.desc "Set image to be publicly visible (true or false)"
      c.default_value "false"
      c.flag [:p, "public"]

      c.desc "Set minimum amount of RAM required by this image (MB)"
      c.flag ["min-ram"]

      c.action do |global_options, options, _args|
        raise "You must specify the architecture" unless options[:a]
        raise "Mode must be 'virtio' or 'compatibility'" unless options[:m] == "virtio" || options[:m] == "compatibility"
        raise "Public must be true or false" unless options[:p] == "true" || options[:p] == "false"

        # Sources are mutually exclusive but at least one is required from this list
        source_options = [:s, :server, :url, :volume].map { |k| options[k] }

        if source_options.none?
          raise "You must specify one of 'server', 'source', 'url', or 'volume'"
        elsif !source_options.one?
          raise "You cannot register from multiple sources. Use either 'source', 'server', 'url', or 'volume'"
        end

        compatibility_flag = options[:m] == "compatibility"

        public_flag = options[:p] == "true"

        image_options = {
          :arch => options[:a],
          :compatibility_mode => compatibility_flag,
          :description => options[:d],
          :min_ram => options["min-ram"].to_i,
          :name => options[:n],
          :public => public_flag,
          :username => options[:u]
        }

        # These should be limited to one by the mutually exclusive check earlier
        image_options[:http_url] = options[:url] if options[:url]
        image_options[:server] = options[:server] if options[:server]
        image_options[:source] = options[:s] if options[:s]
        image_options[:volume] = options[:volume] if options[:volume]

        image = Image.register(image_options)

        render_table([image], global_options)
      end
    end
  end
end
