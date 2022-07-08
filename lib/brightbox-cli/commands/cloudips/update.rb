module Brightbox
  command [:cloudips] do |cmd|
    cmd.desc I18n.t("cloudips.update.desc")
    cmd.arg_name "cloudip-id"
    cmd.command [:update] do |c|
      c.desc "Set reverse DNS for this Cloud IP"
      c.flag [:r, "reverse-dns"]

      c.desc "Delete the reverse DNS for this Cloud IP"
      c.switch ["delete-reverse-dns"], :negatable => false

      c.desc I18n.t("options.name.desc")
      c.flag %i[n name]

      c.desc I18n.t("cloudips.options.port_translators.desc")
      c.flag %i[t port-translators]

      c.action do |global_options, options, args|
        cip_id = args.shift
        raise "You must specify the Cloud IP id as the first argument" unless cip_id =~ /^cip-/

        if options[:r] && options[:r] != "" && options[:"delete-reverse-dns"]
          raise "You must either specify a reverse DNS record or --delete-reverse-dns"
        end

        cip = CloudIP.find cip_id

        cip.update(options)
        cip.reload

        render_table([cip], global_options)
      end
    end
  end
end
