module Brightbox
  desc 'Update an image'
  arg_name 'img-id'
  command [:update] do |c|

    c.desc "Name to give the image"
    c.flag [:n, "name"]

    c.desc "Architecture of the image (i686 or x86_64)"
    c.flag [:a, "arch"]

    c.desc "Set image mode to be either 'virtio' or 'compatibility'"
    c.flag [:m, "mode"]

    c.desc "Set image to be publically visible (true or false)"
    c.flag [:p, "public"]

    c.desc "Image description"
    c.flag [:d, "description"]

    c.desc "Image Usernmae"
    c.flag [:u, "username"]

    c.action do |global_options,options,args|
      img_id = args.shift
      raise "You must specify the image to update as the first argument" unless img_id =~ /^img-/
      if options[:m]
        raise "Mode must be 'virtio' or 'compatibility'" unless options[:m] == "virtio" || options[:m] == "compatibility"
      end
      if options[:p]
        raise "Public must be true or false" unless options[:p] == "true" || options[:p] == "false"
      end

      params = {}
      params[:name]               = options[:n] if options[:n]
      params[:arch]               = options[:a] if options[:a]
      params[:source]             = options[:s] if options[:s]
      params[:description]        = options[:d] if options[:d]
      params[:username]           = options[:u] if options[:u]

      params[:compatibility_mode] = true if options[:m] == "compatibility"
      params[:compatibility_mode] = false if options[:m] == "virtio"

      params[:public] = true if options[:p] == "true"
      params[:public] = false if options[:p] == "false"

      image = Image.find img_id

      info "Updating image #{image}"
      image.update params
      image.reload
      render_table([image], global_options)
    end

  end
end
