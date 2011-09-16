module Brightbox
  desc 'Register an image'
  command [:register] do |c|

    c.desc "Name to give the image"
    c.flag [:n, "name"]

    c.desc "Archtecture of the image (i686 or x86_64)"
    c.flag [:a, "arch"]

    c.desc "Source filename of the image you uploaded to the image library"
    c.flag [:s, "source"]

    c.desc "This image does not support virtio so needs 'compatibility mode'"
    c.switch [:c, "compatibility"]

    c.desc "Image description"
    c.flag [:d, "description"]

    c.action do |global_options,options,args|

      raise "You must specify the architecture" unless options[:a]
      raise "You must specify the source filename" unless options[:s]

      image = Image.register :name => options[:n], :arch => options[:a],
      :source => options[:s], :compatibility_mode => options[:c],
      :description => options[:d]

      render_table([image])

    end
  end
end
