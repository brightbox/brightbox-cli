module Brightbox
  desc 'Create a new cloud ip'
  command [:create] do |c|
    c.desc "Number of cloud ips to create"
    c.default_value 1
    c.flag [:i, "count"]

    c.desc "Friendly name of Cloud ip"
    c.flag [:n, :name]

    c.desc "Cloud ip translators.Format: in-port:out-port:protocol. Comma separated multiple translators. Protocol can be tcp or udp."
    c.flag [:t, :port_translators]

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
