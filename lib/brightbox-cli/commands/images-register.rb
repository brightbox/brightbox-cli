module Brightbox
  desc 'Register an image'
  command [:register] do |c|

    c.desc "Name to give the image"
    c.flag [:n, "name"]

    c.desc "Image Username"
    c.flag [:u, "username"]

    c.desc "Archtecture of the image (i686 or x86_64)"
    c.flag [:a, "arch"]

    c.desc "Source filename of the image you uploaded to the image library"
    c.flag [:s, "source"]

    c.desc "Set image mode to be either 'virtio' or 'compatibility'"
    c.default_value "virtio"
    c.flag [:m, "mode"]

    c.desc "Set image to be publically visible (true or false)"
    c.default_value "false"
    c.flag [:p, "public"]

    c.desc "Image description"
    c.flag [:d, "description"]

    c.action do |global_options,options,args|

      raise "You must specify the architecture" unless options[:a]
      raise "You must specify the source filename" unless options[:s]
      raise "Mode must be 'virtio' or 'compatibility'" unless options[:m] == "virtio" || options[:m] == "compatibility"
      raise "Public must be true or false" unless options[:p] == "true" || options[:p] == "false"

      if options[:m] == "compatibility"
        compatibility_flag = true
      else
        compatibility_flag = false
      end

      if options[:p] == "true"
        public_flag = true
      else
        public_flag = false
      end

      image_options = {
        :name => options[:n], :arch => options[:a],
        :username => options[:u], :source => options[:s],
        :compatibility_mode => compatibility_flag,
        :description => options[:d], :public => public_flag
      }

      image = Image.register(image_options)

      render_table([image])

    end
  end
end
