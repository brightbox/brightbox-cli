module Brightbox
  command [:images] do |cmd|

    cmd.default_command :list

    cmd.desc "List available images"
    cmd.arg_name "[image-id...]"
    cmd.command [:list] do |c|

      c.desc "Show all public images from all accounts"
      c.switch [:a, "show-all"], :negatable => false

      c.desc "Show only images of a given type"
      c.flag [:t, :type]

      c.desc "Show only images of a given status"
      c.flag [:s, :status]

      c.desc "Show only images for a given account identifier"
      c.flag [:l, :account]

      c.action do |global_options, options, args|

        if args.empty?
          images = Image.find(:all)
        else
          images = Image.find_or_call(args) do |id|
            warn "Couldn't find image #{id}"
          end
        end

        images = Image.filter_images(images, options)
        render_table(images, global_options)
      end
    end
  end
end
