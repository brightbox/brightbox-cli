module Brightbox
  desc I18n.t("cloudips.desc")
  command [:cloudips] do |cmd|

    cmd.desc I18n.t("cloudips.create.desc")
    cmd.command [:create] do |c|

      c.desc "Number of Cloud IPs to create"
      c.default_value 1
      c.flag [:i, "count"]

      c.desc I18n.t("options.name.desc")
      c.flag [:n, :name]

      c.desc I18n.t("cloudips.options.port_translators.desc")
      c.flag [:t, :"port-translators"]

      c.action do |global_options, options, args|

        if options[:i].to_s !~ /^[0-9]+$/
          raise "count must be a number"
        end

        options[:i] = options[:i].to_i

        ips = []
        options[:i].times do
          ips << CloudIP.create(options)
        end
        render_table(ips, global_options)
      end
    end
  end
end
