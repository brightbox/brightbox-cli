module Brightbox
  command [:cloudips] do |cmd|

    cmd.desc I18n.t("cloudips.show.desc")
    cmd.arg_name "cloudip-id..."
    cmd.command [:show] do |c|

      c.action do |global_options, _options, args|

        if args.empty?
          raise "You must specify the cloud ips you want to show"
        end

        ips = CloudIP.find_or_call(args) do |id|
          warn "Couldn't find Cloud IP #{id}"
        end

        fields = [
          :id,
          :name,
          :status,
          :public_ip,
          :fqdn,
          :reverse_dns,
          :destination,
          :interface_id,
          :port_translators
        ]

        render_table(ips.compact, global_options.merge(:vertical => true, :fields => fields))
      end
    end
  end
end
