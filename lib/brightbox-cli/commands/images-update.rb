module Brightbox
  desc 'Update an image'
  arg_name 'img-id'
  command [:update] do |c|

    c.desc "Name to give the image"
    c.flag [:n, "name"]

    c.desc "Archtecture of the image (i686 or x86_64)"
    c.flag [:a, "arch"]

    c.desc "This image does not support virtio so needs 'compatibility mode'"
    c.switch [:c, "compatibility"]

    c.desc "Public image"
    c.switch [:public]

    c.desc "Private image"
    c.switch [:private]

    c.desc "Image description"
    c.flag [:d, "description"]

    c.action do |global_options,options,args|
      img_id = args.shift
      raise "You must specify the load balancer to update as the first argument" unless img_id =~ /^img-/
      raise "You must specify public or private, not both" if options[:public] && options[:private]

      params = {}
      params[:name]               = options[:n] if options[:n]
      params[:arch]               = options[:a] if options[:a]
      params[:source]             = options[:s] if options[:s]
      params[:compatibility_mode] = options[:c] if options[:c]
      params[:description]        = options[:d] if options[:d]

      params[:public] = true if options[:public]
      params[:public] = false if options[:private]

      image = Image.find img_id

      info "Updating image #{image}"
      image.update params
      image.reload
      render_table([image], global_options)
    end

  end
end
