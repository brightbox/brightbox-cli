module Brightbox
  desc 'List available images'
  arg_name '[image-id...]'
  command [:list] do |c|
    c.desc "Show all public images from all accounts"
    c.switch [:a, "show-all"]

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

      # Filter out images that are not of the right type, account or status if the option is passed
      if options[:t] || options[:s] || options[:l]
        images.reject! { |i| (options[:t] && i.type != options[:t]) || (options[:s] && i.status != options[:s]) || (options[:l] && i.owner_id != options[:l]) }
      end

      snapshots = images.select { |i| i.source_type == 'snapshot' }

      images = images - snapshots

      unless options[:a]
        account = Account.conn_account
        images.reject! { |i| !i.official and i.owner_id != account.id  }
      end

      images.sort! { |a, b| a.default_sort_fields <=> b.default_sort_fields }

      snapshots.sort! { |a, b| a.created_at <=> b.created_at }

      render_table(images + snapshots, global_options)
    end
  end
end
