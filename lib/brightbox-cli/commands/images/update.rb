module Brightbox
  command [:images] do |cmd|
    cmd.desc I18n.t("images.update.desc")
    cmd.arg_name "img-id"
    cmd.command [:update] do |c|
      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("options.description.desc")
      c.flag %i[d description]

      c.desc "Architecture of the image (i686 or x86_64)"
      c.flag [:a, "arch"]

      c.desc "Set image mode to be either 'virtio' or 'compatibility'"
      c.flag [:m, "mode"]

      c.desc "Set image to be publicly visible (true or false)"
      c.flag [:p, "public"]

      c.desc "Set image to be deprecated (true or false)"
      c.flag "deprecated"

      c.desc "Image Username"
      c.flag [:u, "username"]

      c.action do |global_options, options, args|
        img_id = args.shift
        raise "You must specify the image to update as the first argument" unless img_id =~ /^img-/

        if options[:m] && !(options[:m] == "virtio" || options[:m] == "compatibility")
          raise "Mode must be 'virtio' or 'compatibility'"
        end
        if options[:p] && !(options[:p] == "true" || options[:p] == "false")
          raise "Public must be true or false"
        end

        params = NilableHash.new
        params[:name]               = options[:n] if options[:n]
        params[:arch]               = options[:a] if options[:a]
        params[:source]             = options[:s] if options[:s]
        params[:description]        = options[:d] if options[:d]
        params[:username]           = options[:u] if options[:u]

        params[:compatibility_mode] = true if options[:m] == "compatibility"
        params[:compatibility_mode] = false if options[:m] == "virtio"

        params[:public] = true if options[:p] == "true"
        params[:public] = false if options[:p] == "false"

        # If options[:deprecated] isn't specified, leave the status alone
        params[:status] = "deprecated" if options[:deprecated] == "true"
        params[:status] = "available" if options[:deprecated] == "false"

        params.nilify_blanks

        image = Image.find img_id

        info "Updating image #{image}"
        image.update params
        image.reload
        render_table([image], global_options)
      end
    end
  end
end
