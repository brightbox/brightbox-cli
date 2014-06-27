module Brightbox
  command [:images] do |cmd|

    cmd.desc I18n.t("images.show.desc")
    cmd.arg_name "image-id..."
    cmd.command [:show] do |c|

      c.action do |global_options, _options, args|
        images = Image.find_all_or_warn(args)

        display_options = {
          :vertical => true,
          :fields => [
            :id, :type, :owner, :created_at, :status, :arch, :name,
            :description, :username, :virtual_size, :disk_size, :public,
            :"compatibility_mode", :official, :ancestor_id, :licence_name
          ]
        }

        table_opts = global_options.merge(display_options)

        render_table(images, table_opts)
      end
    end
  end
end
