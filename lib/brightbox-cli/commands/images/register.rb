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

      c.action do |global_options, options, _args|
        raise "You must specify the architecture" unless options[:a]
        raise "You must specify the source filename" unless options[:s]
        raise "Mode must be 'virtio' or 'compatibility'" unless options[:m] == "virtio" || options[:m] == "compatibility"
        raise "Public must be true or false" unless options[:p] == "true" || options[:p] == "false"

        compatibility_flag = options[:m] == "compatibility"

        public_flag = options[:p] == "true"

        image_options = {
          :name => options[:n], :arch => options[:a],
          :username => options[:u], :source => options[:s],
          :compatibility_mode => compatibility_flag,
          :description => options[:d], :public => public_flag
        }

        image = Image.register(image_options)

        render_table([image], global_options)
      end
    end
  end
end
