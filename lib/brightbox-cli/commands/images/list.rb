module Brightbox
  command [:images] do |cmd|
    cmd.default_command :list

    cmd.desc I18n.t("images.list.desc")
    cmd.arg_name "[image-id...]"
    cmd.command [:list] do |c|
      c.desc "Show all public images from all accounts"
      c.switch [:a, "show-all"], :negatable => false

      c.desc "Show only images of a given type"
      c.flag %i[t type]

      c.desc "Show only images of a given status"
      c.flag %i[s status]

      c.desc "Show only images for a given account identifier"
      c.flag %i[l account]

      c.action do |global_options, options, args|
        images = Image.find_all_or_warn(args)
        images = Image.filter_images(images, options)
        render_table(images, global_options)
      end
    end
  end
end
