module Brightbox
  command [:lbs] do |cmd|

    cmd.desc I18n.t("lbs.create.desc")
    cmd.long_desc I18n.t("lbs.create.long_desc")
    cmd.arg_name "srv-id..."
    cmd.command [:create] do |c|

      c.desc I18n.t("options.name.desc")
      c.flag [:n, :name]

      c.desc "Load balancer policy"
      c.default_value "least-connections"
      c.flag [:p, :policy]

      c.desc "Listeners. Format: in-port:out-port:type:timeout. Comma separated multiple listeners. Protocols can be tcp, http or http+ws and timeouts are in milliseconds."
      c.default_value "80:80:http:50000,443:443:tcp:50000"
      c.flag [:l, :listeners]

      c.desc "Healthcheck port. Defaults to first listener out port."
      c.flag [:k, "hc-port"]

      c.desc "Healthcheck type. Defaults to first listener protocol."
      c.flag [:y, "hc-type"]

      c.desc "Buffer Size. Defaults to 4096 bytes"
      c.flag [:b, "buffer-size"]

      c.desc "Healthcheck timeout"
      c.default_value "5000"
      c.flag [:t, "hc-timeout"]

      c.desc "Healthcheck request. When the type is 'http' this is the url to request."
      c.default_value "/"
      c.flag [:s, "hc-request"]

      c.desc "Healthcheck interval"
      c.default_value "5000"
      c.flag [:e, "hc-interval"]

      c.desc "Healthcheck threshold up. Number of successful healthchecks for the node to be considered up."
      c.default_value "3"
      c.flag [:u, "hc-up"]

      c.desc "Healthcheck threshold down. Number of failed healthchecks for the node to be considered down."
      c.default_value "3"
      c.flag [:d, "hc-down"]

      c.desc "Filepath to the SSL certificate file to use."
      c.flag ["ssl-cert"]

      c.desc "Filepath to the private key used to sign SSL certificate (OpenSSL supported formats)."
      c.flag ["ssl-key"]

      c.desc "Enable SSL v3 support"
      c.switch ["sslv3"]

      c.action do |global_options, options, args|

        raise "You must specify which servers to balance connections to" if args.empty?

        listeners = options[:l].split(",").map do |l|
          inport, outport, protocol, timeout = l.split ":"
          raise "listener '#{l}' is invalid" if inport.nil? || outport.nil? || protocol.nil?
          { :in => inport, :out => outport, :protocol => protocol, :timeout => timeout }
        end

        raise "You must specify at least one listener" if listeners.empty?

        # Setup default healthcheck port if not specified
        if options[:k].nil?
          options[:k] = listeners.first[:out]
        end

        if options[:y].nil?
          options[:y] = listeners.first[:protocol]
        end

        hc_arg_lookup = {
          :k => :port,
          :y => :type,
          :t => :timeout,
          :s => :request,
          :e => :interval,
          :u => :threshold_up,
          :d => :threshold_down
        }

        healthcheck = {}

        options.keys.each do |k|
          if options[k] && hc_arg_lookup[k]
            healthcheck[hc_arg_lookup[k]] = options[k]
          end
        end

        # SSL argumens
        ssl_cert_path = options["ssl-cert"]
        ssl_key_path = options["ssl-key"]

        if ssl_cert_path.nil? ^ ssl_key_path.nil?
          raise "Both SSL arguments (ssl-cert and ssl-key) are required."
        end

        if ssl_cert_path && ssl_key_path
          ssl_cert = File.read(File.expand_path(ssl_cert_path))
          ssl_key = File.read(File.expand_path(ssl_key_path))
        end

        nodes = args.map { |i| { :node => i } }

        msg = "Creating a new load balancer"
        info msg
        lb = LoadBalancer.create(:policy => options[:policy],
                                 :name => options[:n],
                                 :buffer_size => options[:b],
                                 :healthcheck => healthcheck,
                                 :listeners => listeners,
                                 :certificate_pem => ssl_cert,
                                 :certificate_private_key => ssl_key,
                                 :sslv3 => options["sslv3"],
                                 :nodes => nodes)
        render_table([lb], global_options)
      end
    end
  end
end
