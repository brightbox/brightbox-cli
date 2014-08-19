module Brightbox
  command [:images] do |cmd|
    cmd.desc I18n.t("images.lock.desc")
    cmd.arg_name "[image-id...]"
    cmd.command [:lock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify image as arguments" if args.empty?

        images = Image.find_or_call(args) do |image|
          raise "Couldn't find #{image}"
        end

        images.each do |image|
          info "Locking #{image}"
          image.lock!
        end
      end
    end

    cmd.desc I18n.t("images.unlock.desc")
    cmd.arg_name "[image-id...]"
    cmd.command [:unlock] do |c|
      c.action do |_global_options, _options, args|
        raise "You must specify images as arguments" if args.empty?

        images = Image.find_or_call(args) do |image|
          raise "Couldn't find #{image}"
        end

        images.each do |image|
          info "Unlocking #{image}"
          image.unlock!
        end
      end
    end
  end
end
