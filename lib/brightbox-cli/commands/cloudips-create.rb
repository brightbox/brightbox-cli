module Brightbox
  desc 'Create a new Cloud IP address'
  command [:create] do |c|
    c.desc "Number of Cloud IPs to create"
    c.default_value 1
    c.flag [:i, "count"]

    c.desc "Friendly name of the Cloud IP"
    c.flag [:n, :name]

    c.desc "Cloud IP translators. Format: in-port:out-port:protocol. Comma separate multiple translators. Protocol can be tcp or udp."
    c.flag [:t, :'port-translators']

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
