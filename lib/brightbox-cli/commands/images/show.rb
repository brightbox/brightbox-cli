module Brightbox
  command [:images] do |cmd|
    cmd.desc I18n.t("images.show.desc")
    cmd.arg_name "image-id..."
    cmd.command [:show] do |c|
      c.action do |global_options, _options, args|
        raise "You must specify image IDs to show" if args.empty?

        images = Image.find_or_call(args) do |id|
          raise "Couldn't find an image with ID #{id}"
        end

        display_options = {
          :vertical => true,
          :fields => %i[
            id
            type
            owner
            created_at
            status
            locked
            arch
            name
            description
            username
            virtual_size
            disk_size
            public
            compatibility_mode
            official
            ancestor_id
            licence_name
            min_ram
          ]
        }

        table_opts = global_options.merge(display_options)

        render_table(images, table_opts)
      end
    end
  end
end
