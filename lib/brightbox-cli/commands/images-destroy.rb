module Brightbox
  desc 'Destroy images'
  arg_name 'image-id...'
  command [:destroy] do |c|

    c.action do |global_options,options,args|

      if args.empty?
        raise "You must specify the images you want to destroy"
      end

      images = Image.find_or_call(args) do |id|
        raise "Couldn't find image #{id}"
      end

      images.each do |i|
        info "Destroying image #{i}"
        i.destroy
        i.reload
      end

      render_table(images, global_options)

    end
  end
end
